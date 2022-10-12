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
	
	pastaProjeto: one Pasta,
	bug: lone Bug,
	relatorioBug: lone RelatorioBug
}{
	bug = relatorioBug.bug //Relatório específico do Bug em questão
}

sig VersaoProjeto {}

sig Pasta { 

	versaoProjeto: some VersaoProjeto
}

sig Bug{}

sig RelatorioBug{
	
	bug: one Bug,
	gravidade: Int
}{
	gravidade>0 //Gravidade varia de 1 até 3, 1 = Bug simples, 2 = Bug complexo e 3 = Bug crítico
	gravidade<4
}

sig CacadoresBug{
	
	bugParaConserto: one Bug,
	diaTrabalho: some Dia
}

abstract sig Dia{}

one sig Segunda, Terca, Quarta, Quinta, Sexta, Sabado, Domingo extends Dia{}

//Diferenciar o nome das pastas com as versões do projeto
fact {
	
	//all vp: VersaoProjeto | one p:Pasta | vp in p.versaoProjeto
	all vp:VersaoProjeto | #(~versaoProjeto)[vp]=1
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
	
	CacadoresBug.bugParaConserto = Projeto.bug
}

//Garantir que ninguem da equipe de Caçadores de Bug trabalhe em um bug por dois dias seguidos
fact {
	
	all cb:CacadoresBug | (Segunda in cb.diaTrabalho implies Terca not in cb.diaTrabalho)
	&& (Terca in cb.diaTrabalho implies Quarta not in cb.diaTrabalho)
	&& (Quarta in cb.diaTrabalho implies Quinta not in cb.diaTrabalho)
	&& (Quinta in cb.diaTrabalho implies Sexta not in cb.diaTrabalho)
	&& (Sexta in cb.diaTrabalho implies Sabado not in cb.diaTrabalho)
	&& (Sabado in cb.diaTrabalho implies Domingo not in cb.diaTrabalho)
	&& (Domingo in cb.diaTrabalho implies Segunda not in cb.diaTrabalho)
}

pred show(){}

run show for 5 but exactly 5 VersaoProjeto, 3 Cliente

/*----------------------------------------------------------------------------------------------------------------------------------
							PREDICADOS
----------------------------------------------------------------------------------------------------------------------------------*/

//Verificar se o risco do Bug está entre Complexo e Gravíssimo
pred riscoGraveBugProjeto (p:Projeto){
	
	one rb:RelatorioBug | p.bug in rb.bug && rb.gravidade > 1
}

//Verificar se o projeto de um determinado cliente contém mais de 1 versão em sua pasta
pred numVersaoPorProjeto (p:Projeto) {

	#(p.pastaProjeto.versaoProjeto) > 1
}

//Verificar se há Caçador de Bug com menos de 3 dias de trabalho
pred cacadorMenosOcupado (c:CacadoresBug) {

	#(c.diaTrabalho) < 3
}

//Verificar se há a pasta desejada por cliente 
pred verificarSeTemPastaEspecificaPorCliente (p:Pasta, c:Cliente) {

	p in c.projeto.pastaProjeto
}

//Verificar se duas equipes estão trabalhando em algum dia igual
pred verificarEquipesMesmoDia (cb1:CacadoresBug, cb2:CacadoresBug) {
	#(cb1.diaTrabalho & cb2.diaTrabalho) > 0
}
