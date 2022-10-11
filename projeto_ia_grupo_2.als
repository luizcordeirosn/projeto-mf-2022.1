/*
Projeto da Disciplina de Métodos Formais

Equipe:
- Cheldon Andrade
- João Santos
- Luiz Cordeiro
*/

sig Cliente {
	
	projeto: Projeto
}

sig Projeto{
	
	pastaProjeto: one Pasta,
	bug: lone Bug	
}

sig Pasta { 

	subPasta: some Pasta
}

sig Bug{}

sig RelatorioBug{
	
	gravidade: Int,	
	bug: one Bug
}{
	gravidade>0
	gravidade<4
}

sig TeamBugFixer{
	
	bugFix: one Bug,
	diaTrabalho: some Dia
}

abstract sig Dia{}

one sig Segunda, Terca, Quarta, Quinta, Sexta, Sabado, Domingo extends Dia{}

//Não repetição de subPastas iguais as próprias pastas
fact{

	all p:Pasta | p not in p.subPasta 
}

//Gerar apenas relatórios dos bugs encontrados em cada projeto
fact {

	all proj: Projeto | no proj.bug => no RelatorioBug
	#RelatorioBug = #Projeto.bug
}

//Apresentar relatórios apenas dos bugs encontrados nos projetos
fact {
	
	RelatorioBug.bug = Projeto.bug
}

//Caçadores de bug trabalharem apenas nos bugs do Projeto
fact {
	
	TeamBugFixer.bugFix = Projeto.bug
}

pred show(){}

run show
