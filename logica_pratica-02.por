programa {
  funcao inicio() {

    real km, litros, preco
    real rendimento, custoDiesel, custoKm

     escreva("Digite os km rodados: ")
     leia(km)

     escreva("Digite os litros consumidos: ")
     leia(litros)

     escreva("Digite o preco do litro do diesel: ")
     leia(preco)

     rendimento = km / litros
     custoDiesel = litros * preco
     custoKm = custoDiesel / km

     escreva("\nRendimento: ", rendimento, " km/l\n")
     escreva("Custo do diesel: R$ ", custoDiesel, "\n")
     escreva("Custo por km: R$ ", custoKm, "\n")

     se (rendimento >= 0.8) {
     escreva("Classificacao: Eficiente")
     }
     senao se (rendimento >= 0.6 e custoKm <= 9.00)
      {
      escreva("Classificacao: Aceitavel")
      } senao{
     escreva("Classificacao: Revisar caminhao")
     }
  }
}
