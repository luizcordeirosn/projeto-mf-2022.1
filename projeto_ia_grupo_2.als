/*
Projeto da Disciplina de Métodos Formais

Equipe:
- Cheldon Andrade
- João Santos
- Luiz Cordeiro
*/

sig Cliente {
	
	projeto: some Projeto
}

sig Projeto{
	
	pastaProjeto: one Pasta
}

sig Pasta{

	subPasta: some Pasta
}

fact verificarSubPasta {
	
	all p:Projeto | p.pastaProjeto not in p.pastaProjeto.subPasta
}

pred show(){}

run show for 3
