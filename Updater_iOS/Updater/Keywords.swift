//
//  Keywords.swift
//  Updater
//
//  Created by Mostafa Mazrouh on 2024-11-30.
//

import Foundation

let sleepDuration: Double = 0.10 // In seconds

// Randam value every time
var newKeyword: String {
    investorKeywords.randomElement() ?? investorKeywords[0]
}

let investorKeywords = [
    // Performance Metrics
    "Revenue", "Earnings", "Profit margin", "EBITDA", "Growth", "Guidance",
    "Forecast", "Operating expenses", "Gross margin", "Cash flow",

    // Market and Competitive Position
    "Market share", "Competition", "Demand", "Supply chain", "Pricing power",
    "Differentiation", "Customer acquisition",

    // Strategic Outlook
    "Expansion", "Innovation", "Investment", "Capital allocation",
    "Acquisitions", "Partnerships", "Strategic initiatives", "Product pipeline",

    // Risks and Challenges
    "Inflation", "Interest rates", "Macroeconomic conditions", "Regulations",
    "Geopolitical risks", "Supply constraints", "Workforce challenges",

    // Shareholder Considerations
    "Dividends", "Share buyback", "Capital return", "Stock performance",
    "Long-term value",

    // Sector-Specific Keywords (examples)
    "Cloud", "AI", "SaaS", "Cybersecurity", "FDA approval", "R&D",
    "Clinical trials", "Production", "Renewable", "Oil prices",

    // Investor Sentiment Indicators
    "Confidence", "Uncertainty", "Optimism", "Outlook"
]
