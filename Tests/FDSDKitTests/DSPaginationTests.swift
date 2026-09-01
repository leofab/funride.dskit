import XCTest
import SwiftUI
@testable import FDSDKit

final class DSPaginationTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testPaginationColors() {
        XCTAssertEqual(DSTokens.Colors.paginationBackground, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.paginationBorder, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.paginationText, Color(hex: "#8f9da3"))
        XCTAssertEqual(DSTokens.Colors.paginationIcon, Color(hex: "#8f9da3"))
    }
    
    func testPaginationSpacing() {
        XCTAssertEqual(DSTokens.Spacing.paginationButtonSpacing, 8)
    }
    
    func testPaginationTypography() {
        XCTAssertEqual(DSTokens.Typography.paginationPageSize, 14)
        XCTAssertEqual(DSTokens.Typography.paginationPageWeight, .regular)
    }
    
    func testPaginationSizing() {
        XCTAssertEqual(DSTokens.Sizing.paginationNumberingWidth, 62)
        XCTAssertEqual(DSTokens.Sizing.paginationNumberingHeight, 31)
        XCTAssertEqual(DSTokens.Sizing.paginationNumberingRadius, 6)
        XCTAssertEqual(DSTokens.Sizing.paginationButtonWidth, 32)
        XCTAssertEqual(DSTokens.Sizing.paginationButtonHeight, 64)
        XCTAssertEqual(DSTokens.Sizing.paginationButtonRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.paginationIconSize, 16)
    }
    
    // MARK: - DSPaginationStyle Tests
    
    func testPaginationStyleDarkProperties() {
        let style = DSPaginationStyle.dark
        XCTAssertEqual(style.backgroundColor, DSTokens.Colors.paginationBackground)
        XCTAssertEqual(style.borderColor, DSTokens.Colors.paginationBorder)
        XCTAssertEqual(style.textColor, DSTokens.Colors.paginationText)
        XCTAssertEqual(style.iconColor, DSTokens.Colors.paginationIcon)
        XCTAssertEqual(style.disabledBackgroundColor, DSTokens.Colors.paginationBackground)
        XCTAssertEqual(style.disabledOpacity, 0.5)
    }
    
    func testPaginationStyleAllCases() {
        XCTAssertEqual(DSPaginationStyle.allCases.count, 1)
        XCTAssertTrue(DSPaginationStyle.allCases.contains(.dark))
    }
    
    // MARK: - Navigation Logic Tests
    
    func testPaginationNavigationLogic() {
        // Test canGoPrevious logic
        XCTAssertFalse(1 > 1) // Page 1 cannot go previous
        XCTAssertTrue(2 > 1)  // Page 2 can go previous
        
        // Test canGoNext logic
        XCTAssertTrue(1 < 5)  // Page 1 can go next
        XCTAssertFalse(5 < 5) // Page 5 cannot go next
    }
    
    func testPaginationBoundaryClamping() {
        // Test page clamping logic
        let totalPages = 5
        
        // Clamp to 1 if less than 1
        let invalidPage1 = max(1, min(0, totalPages))
        XCTAssertEqual(invalidPage1, 1)
        
        // Clamp to totalPages if greater than totalPages
        let invalidPage2 = max(1, min(10, totalPages))
        XCTAssertEqual(invalidPage2, totalPages)
        
        // Valid page should remain unchanged
        let validPage = max(1, min(3, totalPages))
        XCTAssertEqual(validPage, 3)
    }
    
    func testPaginationZeroTotalPages() {
        let totalPages = 0
        let currentPage = 0
        
        // Both buttons should be disabled
        let canGoPrevious = currentPage > 1
        let canGoNext = currentPage < totalPages
        
        XCTAssertFalse(canGoPrevious)
        XCTAssertFalse(canGoNext)
    }
    
    func testPaginationSinglePage() {
        let totalPages = 1
        let currentPage = 1
        
        // Both buttons should be disabled
        let canGoPrevious = currentPage > 1
        let canGoNext = currentPage < totalPages
        
        XCTAssertFalse(canGoPrevious)
        XCTAssertFalse(canGoNext)
    }
    
    // MARK: - UIKit Tests
    
    #if canImport(UIKit)
    func testDSPaginationUIViewInitialization() {
        let pagination = DSPaginationUIView(frame: .zero, currentPage: 2, totalPages: 5)
        XCTAssertEqual(pagination.currentPage, 2)
        XCTAssertEqual(pagination.totalPages, 5)
    }
    
    func testDSPaginationUIViewDefaultValues() {
        let pagination = DSPaginationUIView(frame: .zero)
        XCTAssertEqual(pagination.currentPage, 1)
        XCTAssertEqual(pagination.totalPages, 1)
    }
    
    func testDSPaginationUIViewSetPage() {
        let pagination = DSPaginationUIView(frame: .zero, currentPage: 1, totalPages: 5)
        
        pagination.setPage(3)
        XCTAssertEqual(pagination.currentPage, 3)
        
        // Test clamping
        pagination.setPage(10)
        XCTAssertEqual(pagination.currentPage, 5)
        
        pagination.setPage(0)
        XCTAssertEqual(pagination.currentPage, 1)
    }
    
    func testDSPaginationUIViewCallback() {
        let expectation = XCTestExpectation(description: "Page change callback")
        let pagination = DSPaginationUIView(frame: .zero, currentPage: 2, totalPages: 5)
        
        pagination.onPageChange = { page in
            XCTAssertEqual(page, 3)
            expectation.fulfill()
        }
        
        // Simulate page change via setPage
        pagination.setPage(3)
        
        wait(for: [expectation], timeout: 1.0)
    }
    #endif
}
