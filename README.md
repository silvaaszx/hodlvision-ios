# 🚀 HodlVision

**HodlVision** é um aplicativo iOS nativo desenvolvido para investidores de Bitcoin focados no longo prazo. Mais do que um simples rastreador de portfólio, é um ecossistema completo de simulação financeira (DCA) e gestão de patrimônio com segurança biométrica.

## ✨ Funcionalidades Principais

* 📈 **Cotação em Tempo Real:** Integração com a API pública da CoinGecko utilizando `async/await` para atualizações de preço do Bitcoin ao vivo.
* 🧮 **Simulador DCA (Dollar Cost Averaging):** Calculadora avançada que projeta o acúmulo de frações de BTC e estimação de patrimônio futuro com base em aportes mensais e preço médio.
* 💼 **Smart Wallet (Carteira Inteligente):** Gestão de aportes com banco de dados local. Calcula lucro/prejuízo em tempo real cruzando os dados locais com a cotação ao vivo da rede.
* 🔒 **Segurança de Nível Bancário:** Tela de bloqueio nativa exigindo autenticação biométrica (**Face ID / Touch ID**) para acessar os dados financeiros do usuário.
* 📱 **Home Screen Widget:** Acompanhamento passivo da cotação do ativo diretamente da tela inicial do iPhone, atualizado em background usando **WidgetKit**.

## 🛠 Arquitetura e Tecnologias

O projeto foi construído seguindo as melhores práticas do ecossistema Apple, focado em código limpo, reatividade e modularidade.

* **Linguagem:** Swift
* **Interface:** SwiftUI
* **Arquitetura:** MVVM (Model-View-ViewModel)
* **Persistência Local:** SwiftData (Modern data modeling framework)
* **Requisições de Rede:** URLSession nativo + Concorrência Moderna (`async/await`)
* **Segurança:** LocalAuthentication (Face ID)
* **Extensões:** WidgetKit

## 🚀 Como Rodar o Projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/silvaaszx/hodlvision-ios.git](https://github.com/silvaaszx/hodlvision-ios.git)

   👨‍💻 Autor
Desenvolvido por Matheus Silva

GitHub: @silvaaszx
