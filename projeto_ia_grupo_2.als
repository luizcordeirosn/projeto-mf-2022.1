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
}{

	all p:Pasta | p not in p.subPasta 
}


pred show(){}

run show for 6 Pasta, 2 Projeto, 2 Cliente
