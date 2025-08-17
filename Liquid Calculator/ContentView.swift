//
//  ContentView.swift
//  Liquid Calculator
//
//  Created by Callum Matthews on 17/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var displayValue = "0"
    @State private var previousValue: Double = 0
    @State private var operation: Operation? = nil
    @State private var waitingForOperand = false
    @State private var showingScientific = false
    @State private var angleMode: AngleMode = .degrees
    @State private var memoryValue: Double = 0
    @State private var phase = 0.0
    @State private var isAnimating = false
    @State private var pressedButtonId: String? = nil
    
    enum Operation {
        case add, subtract, multiply, divide
    }
    
    enum AngleMode {
        case degrees, radians
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced liquid glass background
                EnhancedLiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Enhanced liquid glass display
                        enhancedLiquidGlassDisplay
                        
                        // Scientific functions with enhanced liquid glass
                        if showingScientific {
                            enhancedLiquidGlassScientificPanel
                        }
                        
                        // Enhanced liquid glass scientific toggle
                        enhancedLiquidGlassScientificToggle
                        
                        // Native-style calculator buttons with liquid glass
                        nativeStyleCalculatorButtons
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Calculator")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EnhancedLiquidGlassAngleToggle(
                        angleMode: angleMode,
                        action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                angleMode = angleMode == .degrees ? .radians : .degrees
                            }
                        }
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
    
    // MARK: - Display Views
    
    private var enhancedLiquidGlassDisplay: some View {
        VStack(spacing: 8) {
            // Previous calculation display
            if previousValue != 0 || operation != nil {
                HStack {
                    Spacer()
                    Text("\(previousValue, specifier: "%.10g")")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            
            // Main display
            HStack {
                Spacer()
                Text(displayValue)
                    .font(.system(size: 48, weight: .light, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 12)
    }
    
    private var enhancedLiquidGlassScientificPanel: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            ForEach(scientificFunctions, id: \.title) { function in
                EnhancedLiquidGlassButton(
                    title: function.title,
                    subtitle: function.subtitle,
                    type: .scientific,
                    action: { 
                        print("Scientific function tapped: \(function.title)") // Debug
                        function.action() 
                    }
                )
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
        )
        .padding(.bottom, 20) // Add bottom spacing
    }
    
    private var enhancedLiquidGlassScientificToggle: some View {
        Button(action: {
            showingScientific.toggle()
        }) {
            HStack(spacing: 12) {
                Image(systemName: showingScientific ? "chevron.up" : "chevron.down")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(showingScientific ? "HIDE FUNCTIONS" : "SHOW FUNCTIONS")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(1)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var nativeStyleCalculatorButtons: some View {
        VStack(spacing: 12) {
            // Top row: AC, ±, %, ÷
            HStack(spacing: 12) {
                NativeStyleLiquidGlassButton(
                    title: "AC",
                    type: .function,
                    action: { clear() }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "±",
                    type: .function,
                    action: { changeSign() }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "%",
                    type: .function,
                    action: { calculatePercent() }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "÷",
                    type: .operator,
                    action: { setOperation(.divide) }
                )
            }
            
            // Second row: 7, 8, 9, ×
            HStack(spacing: 12) {
                NativeStyleLiquidGlassButton(
                    title: "7",
                    type: .number,
                    action: { appendDigit("7") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "8",
                    type: .number,
                    action: { appendDigit("8") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "9",
                    type: .number,
                    action: { appendDigit("9") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "×",
                    type: .operator,
                    action: { setOperation(.multiply) }
                )
            }
            
            // Third row: 4, 5, 6, -
            HStack(spacing: 12) {
                NativeStyleLiquidGlassButton(
                    title: "4",
                    type: .number,
                    action: { appendDigit("4") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "5",
                    type: .number,
                    action: { appendDigit("5") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "6",
                    type: .number,
                    action: { appendDigit("6") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "-",
                    type: .operator,
                    action: { setOperation(.subtract) }
                )
            }
            
            // Fourth row: 1, 2, 3, +
            HStack(spacing: 12) {
                NativeStyleLiquidGlassButton(
                    title: "1",
                    type: .number,
                    action: { appendDigit("1") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "2",
                    type: .number,
                    action: { appendDigit("2") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "3",
                    type: .number,
                    action: { appendDigit("3") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "+",
                    type: .operator,
                    action: { setOperation(.add) }
                )
            }
            
            // Bottom row: 0, ., =
            HStack(spacing: 12) {
                NativeStyleLiquidGlassButton(
                    title: "0",
                    type: .number,
                    isWide: true,
                    action: { appendDigit("0") }
                )
                
                NativeStyleLiquidGlassButton(
                    title: ".",
                    type: .function,
                    action: { appendDecimal() }
                )
                
                NativeStyleLiquidGlassButton(
                    title: "=",
                    type: .equals,
                    action: { calculate() }
                )
            }
        }
    }
    
    // Scientific functions
    private var scientificFunctions: [(title: String, subtitle: String, action: () -> Void)] {
        [
            ("sin", "Sine", { calculateTrigFunction(.sin) }),
            ("cos", "Cosine", { calculateTrigFunction(.cos) }),
            ("tan", "Tangent", { calculateTrigFunction(.tan) }),
            ("log", "Log", { calculateLog() }),
            ("ln", "Natural Log", { calculateNaturalLog() }),
            ("√", "Square Root", { calculateSquareRoot() }),
            ("x²", "Square", { calculateSquare() }),
            ("x³", "Cube", { calculateCube() }),
            ("xʸ", "Power", { setOperation(.multiply) }), // Simplified for now
            ("ʸ√x", "Root", { setOperation(.divide) }), // Simplified for now
            ("1/x", "Reciprocal", { calculateReciprocal() }),
            ("±", "Sign Change", { changeSign() }),
            ("MC", "Memory Clear", { clearMemory() }),
            ("MR", "Memory Recall", { recallMemory() }),
            ("M+", "Memory Add", { addToMemory() }),
            ("M-", "Memory Subtract", { subtractFromMemory() })
        ]
    }
    
    // MARK: - Calculator Logic
    
    private func appendDigit(_ digit: String) {
        if waitingForOperand {
            displayValue = digit
            waitingForOperand = false
        } else {
            if displayValue == "0" {
                displayValue = digit
            } else {
                displayValue += digit
            }
        }
    }
    
    private func appendDecimal() {
        if waitingForOperand {
            displayValue = "0."
            waitingForOperand = false
        } else if !displayValue.contains(".") {
            displayValue += "."
        }
    }
    
    private func clear() {
        displayValue = "0"
        previousValue = 0
        operation = nil
        waitingForOperand = false
    }
    
    private func deleteLastDigit() {
        if displayValue.count > 1 {
            displayValue.removeLast()
        } else {
            displayValue = "0"
        }
    }
    
    private func setOperation(_ newOperation: Operation) {
        if let _ = operation, !waitingForOperand {
            calculate()
        }
        
        previousValue = Double(displayValue) ?? 0
        operation = newOperation
        waitingForOperand = true
    }
    
    private func calculate() {
        guard let currentOperation = operation else { return }
        
        let currentValue = Double(displayValue) ?? 0
        var result: Double = 0
        
        switch currentOperation {
        case .add:
            result = previousValue + currentValue
        case .subtract:
            result = previousValue - currentValue
        case .multiply:
            result = previousValue * currentValue
        case .divide:
            result = currentValue != 0 ? previousValue / currentValue : 0
        }
        
        displayValue = formatResult(result)
        operation = nil
        waitingForOperand = true
    }
    
    private func calculatePercent() {
        if let value = Double(displayValue) {
            displayValue = formatResult(value / 100)
        }
    }
    
    private func calculateTrigFunction(_ function: TrigFunction) {
        guard let value = Double(displayValue) else { return }
        var result: Double = 0
        
        let angleInRadians = angleMode == .degrees ? value * .pi / 180 : value
        
        switch function {
        case .sin:
            result = sin(angleInRadians)
        case .cos:
            result = cos(angleInRadians)
        case .tan:
            result = tan(angleInRadians)
        }
        
        displayValue = formatResult(result)
        waitingForOperand = true
    }
    
    private func calculateLog() {
        guard let value = Double(displayValue), value > 0 else { return }
        displayValue = formatResult(log10(value))
        waitingForOperand = true
    }
    
    private func calculateNaturalLog() {
        guard let value = Double(displayValue), value > 0 else { return }
        displayValue = formatResult(log(value))
        waitingForOperand = true
    }
    
    private func calculateSquareRoot() {
        guard let value = Double(displayValue), value >= 0 else { return }
        displayValue = formatResult(sqrt(value))
        waitingForOperand = true
    }
    
    private func calculateSquare() {
        guard let value = Double(displayValue) else { return }
        displayValue = formatResult(value * value)
        waitingForOperand = true
    }
    
    private func calculateCube() {
        guard let value = Double(displayValue) else { return }
        displayValue = formatResult(value * value * value)
        waitingForOperand = true
    }
    
    private func calculateReciprocal() {
        guard let value = Double(displayValue), value != 0 else { return }
        displayValue = formatResult(1.0 / value)
        waitingForOperand = true
    }
    
    private func changeSign() {
        if let value = Double(displayValue) {
            displayValue = formatResult(-value)
        }
    }
    
    private func clearMemory() {
        memoryValue = 0
    }
    
    private func recallMemory() {
        displayValue = formatResult(memoryValue)
        waitingForOperand = true
    }
    
    private func addToMemory() {
        if let value = Double(displayValue) {
            memoryValue += value
        }
    }
    
    private func subtractFromMemory() {
        if let value = Double(displayValue) {
            memoryValue -= value
        }
    }
    
    private func formatResult(_ value: Double) -> String {
        if value.isInfinite || value.isNaN {
            return "Error"
        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    enum TrigFunction {
        case sin, cos, tan
    }
}

// MARK: - Enhanced iOS 26 Liquid Glass Components

struct EnhancedLiquidGlassBackground: View {
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            // Enhanced iOS 26 liquid glass gradient
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.04, green: 0.04, blue: 0.12),
                    Color(red: 0.08, green: 0.08, blue: 0.18),
                    Color(red: 0.12, green: 0.12, blue: 0.24)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Optimized liquid glass orbs (reduced count for performance)
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 60 + Double(index * 20), height: 60 + Double(index * 20))
                    .blur(radius: 30)
                    .offset(
                        x: 150 * cos(phase + Double(index) * .pi / 4),
                        y: 150 * sin(phase + Double(index) * .pi / 4)
                    )
                    .opacity(0.5)
                    .scaleEffect(0.8 + 0.3 * sin(phase + Double(index) * .pi / 3))
            }
            
            // Optimized floating particles (reduced count for performance)
            ForEach(0..<10, id: \.self) { index in
                Circle()
                    .fill(.thinMaterial)
                    .frame(width: 4 + Double(index % 3) * 2, height: 4 + Double(index % 3) * 2)
                    .blur(radius: 2)
                    .offset(
                        x: 200 * cos(phase * 1.5 + Double(index) * .pi / 6),
                        y: 200 * sin(phase * 1.5 + Double(index) * .pi / 6)
                    )
                    .opacity(0.6)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 80).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

struct EnhancedLiquidGlassAngleToggle: View {
    let angleMode: ContentView.AngleMode
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(angleMode == .degrees ? "DEG" : "RAD")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .tracking(1)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.4),
                                            .white.opacity(0.1),
                                            .clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
        }
        .buttonStyle(NativeLiquidGlassButtonStyle())
    }
}

struct NativeStyleLiquidGlassButton: View {
    let title: String
    let type: ButtonType
    let isWide: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(title: String, type: ButtonType, isWide: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.isWide = isWide
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            
            action()
        }) {
            Text(title)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: isWide ? 160 : 80, height: 80)
                .background(
                    ZStack {
                        // Base button background
                        Circle()
                            .fill(backgroundColor)
                        
                        // Liquid glass effect on press
                        if isPressed {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.6)
                                .scaleEffect(1.1)
                                .blur(radius: 2)
                        }
                        
                        // Enhanced glass overlay
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.4),
                                        .white.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .shadow(color: .black.opacity(0.3), radius: isPressed ? 15 : 20, x: 0, y: isPressed ? 8 : 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        switch type {
        case .number:
            return Color(red: 0.2, green: 0.2, blue: 0.25)
        case .operator:
            return Color.orange
        case .function:
            return Color(red: 0.15, green: 0.15, blue: 0.2)
        case .equals:
            return Color.orange
        case .scientific:
            return Color(red: 0.1, green: 0.1, blue: 0.15)
        }
    }
}

struct EnhancedLiquidGlassButton: View {
    let title: String
    let subtitle: String
    let type: ButtonType
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            
            action()
        }) {
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                        .tracking(0.5)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                ZStack {
                    // Base button background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    // Liquid glass effect on press
                    if isPressed {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                            .opacity(0.8)
                            .scaleEffect(1.05)
                            .blur(radius: 1)
                    }
                    
                    // Enhanced glass overlay
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(color: .black.opacity(0.2), radius: isPressed ? 8 : 12, x: 0, y: isPressed ? 4 : 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum ButtonType {
    case number, `operator`, function, equals, scientific
}

struct NativeLiquidGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .blur(radius: 15)
                            .opacity(0.6)
                            .scaleEffect(1.1)
                            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
                    }
                }
            )
    }
}

#Preview {
    ContentView()
}
