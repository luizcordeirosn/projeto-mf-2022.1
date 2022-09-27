sig Cliente {
	
	projeto: some Projeto
}

sig Projeto{
	
	pastaProjeto: one Pasta
}

sig Pasta{

	subPasta: some Pasta
}


pred show(){}

run show for 3
