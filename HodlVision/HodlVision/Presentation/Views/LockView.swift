import SwiftUI
import LocalAuthentication

struct LockView: View {
    @State private var isUnlocked = false
    @State private var authenticationFailed = false
    
    var body: some View {
        Group {
            // Se estiver desbloqueado, mostra o App inteiro!
            if isUnlocked {
                MainTabView()
            } else {
                // Se estiver bloqueado, mostra a tela do cofre
                VStack(spacing: 20) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.orange)
                        .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Text("HodlVision Bloqueado")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Seu patrimônio está protegido.")
                        .foregroundStyle(.secondary)
                    
                    Button(action: authenticate) {
                        Text("Desbloquear com Face ID")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    
                    if authenticationFailed {
                        Text("Não foi possível reconhecer seu rosto.")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.top, 10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.ignoresSafeArea())
                .onAppear(perform: authenticate) // Tenta abrir logo de cara
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // Verifica se o iPhone tem Face ID/Touch ID ou Senha ativada
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Acesse sua carteira de Bitcoin."
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // O DispatchQueue garante que a tela atualize na thread principal
                DispatchQueue.main.async {
                    if success {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            self.isUnlocked = true
                        }
                    } else {
                        self.authenticationFailed = true
                    }
                }
            }
        } else {
            // Se o usuário não tiver nem senha no celular, deixa passar (ou força a criar uma)
            self.isUnlocked = true
        }
    }
}

#Preview {
    LockView()
        .preferredColorScheme(.dark)
}
