//
//  Copyright 2022 Eigo Madaloja
//

import StoreKit
import RxSwift
import RxCocoa

public class PurchaseService {
    var autoSolvingProduct: Observable<Product?> {
        autoSolvingProductRelay
            .observe(on: MainScheduler.instance)
            .asObservable()
    }

    var isPurchasingAutoSolving: Observable<Bool> {
        isPurchasingAutoSolvingRelay
            .observe(on: MainScheduler.instance)
            .asObservable()
    }

    var isRestoringPurchases: Observable<Bool> {
        isRestoringPurchasesRelay
            .observe(on: MainScheduler.instance)
            .asObservable()
    }

    var purchaseAutoSolvingFailure: Observable<Error> {
        purchaseAutoSolvingFailureSubject
            .observe(on: MainScheduler.instance)
            .asObservable()
    }

    var restorePurchasesFailure: Observable<Error> {
        restorePurchasesFailureSubject
            .observe(on: MainScheduler.instance)
            .asObservable()
    }

    private let purchaseDeliverer: PurchasedProductDeliverer
    private let autoSolvingProductID = "autosolve"
    private let autoSolvingProductRelay = BehaviorRelay<Product?>(value: nil)
    private let productsLoadingFailureSubject = PublishSubject<Error>()
    private let isPurchasingAutoSolvingRelay = BehaviorRelay<Bool>(value: false)
    private let purchaseAutoSolvingFailureSubject = PublishSubject<Error>()
    private let isRestoringPurchasesRelay = BehaviorRelay<Bool>(value: false)
    private let restorePurchasesFailureSubject = PublishSubject<Error>()
    private var updateListenerTask: Task<Void, Error>?

    public init(
        purchaseDeliverer: PurchasedProductDeliverer
    ) {
        self.purchaseDeliverer = purchaseDeliverer

        startListeningForTransactions()

        Task { await updatePurchases() }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func loadProducts() {
        Task {
            do {
                let products = try await Product.products(for: [autoSolvingProductID])

                if let autoSolveProduct = products.first(where: { $0.id == autoSolvingProductID }) {
                    autoSolvingProductRelay.accept(autoSolveProduct)
                }
            } catch {
                productsLoadingFailureSubject.onNext(error)
            }
        }
    }

    func purchaseAutoSolving() {
        guard let autoSolveProduct = autoSolvingProductRelay.value else { return }

        Task {
            do {
                isPurchasingAutoSolvingRelay.accept(true)

                let result = try await autoSolveProduct.purchase()

                switch result {
                case .success(let verificationResult):
                    guard
                        let verifiedTransaction = verifiedTransaction(verificationResult)
                    else {
                        isPurchasingAutoSolvingRelay.accept(false)
                        return
                    }

                    await updatePurchases()
                    await verifiedTransaction.finish()
                    isPurchasingAutoSolvingRelay.accept(false)
                case .userCancelled, .pending:
                    isPurchasingAutoSolvingRelay.accept(false)
                @unknown default:
                    isPurchasingAutoSolvingRelay.accept(false)
                }
            } catch {
                isPurchasingAutoSolvingRelay.accept(false)
                purchaseAutoSolvingFailureSubject.onNext(error)
            }
        }
    }

    func restorePurchases() {
        Task {
            do {
                isRestoringPurchasesRelay.accept(true)
                try await AppStore.sync()
                isRestoringPurchasesRelay.accept(false)
            } catch {
                isRestoringPurchasesRelay.accept(false)
                restorePurchasesFailureSubject.onNext(error)
            }
        }
    }

    private func updatePurchases() async {
        let verifiedTransactions = await Transaction.currentEntitlements
            .collect()
            .compactMap(verifiedTransaction(_:))

        if verifiedTransactions.contains(where: { $0.productID == autoSolvingProductID }) {
            DispatchQueue.main.async { [weak self] in
                self?.purchaseDeliverer.deliverAutoSolving()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.purchaseDeliverer.revokeAutoSolving()
            }
        }
    }

    private func startListeningForTransactions() {
        stopListeningForTransactions()

        updateListenerTask = Task.detached {
            for await verificationResult in Transaction.updates {
                guard let verifiedTransaction = self.verifiedTransaction(verificationResult) else {
                    continue
                }

                await self.updatePurchases()
                await verifiedTransaction.finish()
            }
        }
    }

    private func stopListeningForTransactions() {
        updateListenerTask?.cancel()
    }

    private func verifiedTransaction(_ verificationResult: VerificationResult<Transaction>) -> Transaction? {
        switch verificationResult {
        case .unverified:
            return nil
        case .verified(let transaction):
            return transaction
        }
    }
}
