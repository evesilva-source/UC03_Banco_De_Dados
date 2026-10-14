programa
{
	funcao inicio()
	{
		// Constante para a capacidade do palete
	 inteiro CAIXAS_POR_PALETE = 40
		
		// Variáveis de tipos diferentes
		inteiro quantidadeCaixas, paletesCompletos, caixasSobra
		real pesoCaixa, pesoTotal, temperatura
		
		// Entrada de dados
		escreva("Digite a quantidade de caixas produzidas: ")
		leia(quantidadeCaixas)
		
		escreva("Digite o peso de cada caixa (kg): ")
		leia(pesoCaixa)
		
		escreva("Digite a temperatura da câmara (°C): ")
		leia(temperatura)
		
		// 1. Cálculo do peso total produzido
		pesoTotal = quantidadeCaixas * pesoCaixa
		
		// 2. Cálculo de paletes completos e sobras (Divisão inteira e Resto)
		paletesCompletos = quantidadeCaixas / CAIXAS_POR_PALETE
		caixasSobra = quantidadeCaixas % CAIXAS_POR_PALETE
		
		// Exibição dos resultados numéricos
		escreva("\n--- RESULTADOS ---\n")
		escreva("\n1. Peso total produzido: ", pesoTotal, " kg")
		escreva("\n2. Paletes completos: ", paletesCompletos)
		escreva("\n3. Caixas que sobram para o próximo turno: ", caixasSobra)
		escreva("\n4. Status: ")
		
		// 3. Condição com "e" para liberação ou motivos de bloqueio
		se (temperatura <= -18.0 e paletesCompletos > 0)
		{
			escreva("Carregamento liberado")
		}
		senao
		{
			// Verifica os motivos específicos do bloqueio
			se (temperatura > -18.0)
			{
				escreva("Bloqueado - Câmara acima de −18 °C")
			}
			se (paletesCompletos == 0)
			{
				escreva("Bloqueado - Nenhum palete completo")
			}
		}
	}
}
