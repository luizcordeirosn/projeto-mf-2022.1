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
	bugProjeto: lone Bug,
	relatorioBug: lone RelatorioBug
}{
	bugProjeto = relatorioBug.bug //Relatório específico do Bug em questão
}

sig VersaoProjeto {}

sig Pasta { 

	versaoProjeto: some VersaoProjeto
}

sig Bug{

	diaTrabalho: some Dia
}

sig RelatorioBug{
	
	bug: one Bug,
	gravidade: Int
}{
	gravidade>0 //Gravidade varia de 1 até 3, 1 = Bug simples, 2 = Bug complexo e 3 = Bug crítico
	gravidade<4
}

sig CacadoresBug{
	
	bugParaConserto: some Bug,
}

abstract sig Dia{}

one sig Segunda, Terca, Quarta, Quinta, Sexta, Sabado, Domingo extends Dia{}

//Diferenciar o nome das pastas com as versões do projeto
fact {
	
	//all vp: VersaoProjeto | one p:Pasta | vp in p.versaoProjeto
	all vp:VersaoProjeto | #(~versaoProjeto)[vp]=1
}

// Fato para que não exista projetos sem clientes atrelados
fact {
	
	all p:Projeto | one c:Cliente | p in c.projeto
}

//Definir uma pasta diferente para cada projeto
fact {
	
	all p:Pasta | one proj:Projeto | p in proj.pastaProjeto
}

//Gerar apenas relatórios dos bugs encontrados em cada projeto
fact {

	all proj: Projeto | no proj.bugProjeto => no RelatorioBug
	#RelatorioBug = #Projeto.bugProjeto
}

//Apresentar relatórios apenas dos bugs encontrados nos projetos
fact {
	
	RelatorioBug.bug = Projeto.bugProjeto
}

//Caçadores de bug trabalharem apenas nos bugs do Projeto
fact {
	
	CacadoresBug.bugParaConserto = Projeto.bugProjeto
}

//Garantir que equipes diferentes não trabalhem no mesmo bug em dias consecutivos
fact {

	all b:Bug | one cb:CacadoresBug | b in cb.bugParaConserto
}

//Equipes trabalharem nos projetos de mesmo cliente em dias diferentes
fact {

	all c:Cliente | one cb: CacadoresBug | bugProjeto[projeto[c]] not in cb.bugParaConserto
}

//Garantir que ninguem da equipe de Caçadores de Bug trabalhe em um bug por dois dias seguidos
fact {
	
	all b:Bug | (Segunda in b.diaTrabalho implies Terca not in b.diaTrabalho)
	&& (Terca in b.diaTrabalho implies Quarta not in b.diaTrabalho)
	&& (Quarta in b.diaTrabalho implies Quinta not in b.diaTrabalho)
	&& (Quinta in b.diaTrabalho implies Sexta not in b.diaTrabalho)
	&& (Sexta in b.diaTrabalho implies Sabado not in b.diaTrabalho)
	&& (Sabado in b.diaTrabalho implies Domingo not in b.diaTrabalho)
	&& (Domingo in b.diaTrabalho implies Segunda not in b.diaTrabalho)
}

pred show(){}

run show for 5

/*----------------------------------------------------------------------------------------------------------------------------------
							PREDICADOS
----------------------------------------------------------------------------------------------------------------------------------*/

//Verificar se o risco do Bug está entre Complexo e Gravíssimo
pred riscoGraveBugProjeto (p:Projeto){
	
	one rb:RelatorioBug | p.bugProjeto in rb.bug && rb.gravidade > 1
}

//Verificar se o projeto de um determinado cliente contém mais de 1 versão em sua pasta
pred numVersaoPorProjeto (p:Projeto) {

	#(p.pastaProjeto.versaoProjeto) > 1
}

//Verificar se há Caçador de Bug com menos de 3 dias de trabalho
pred cacadorMenosOcupado (cb:CacadoresBug) {

	#diaTrabalho[bugParaConserto[cb]] < 3
}

//Verificar se há a pasta desejada por cliente 
pred verificarSeTemPastaEspecificaPorCliente (p:Pasta, c:Cliente) {

	p in c.projeto.pastaProjeto
}

//Verificar se duas equipes estão trabalhando em algum dia igual
pred verificarEquipesMesmoDia (cb1:CacadoresBug, cb2:CacadoresBug) {
	#(diaTrabalho[bugParaConserto[cb1]] & diaTrabalho[bugParaConserto[cb2]]) > 0
}

/*----------------------------------------------------------------------------------------------------------------------------------
							FUNÇÕES
----------------------------------------------------------------------------------------------------------------------------------*/

//Retornar a gravidade de um Bug relatado
fun gravidadeDoBug(r:RelatorioBug) : Int {

	r.gravidade
}
//Retornar quantidade total de equipes
fun qtdEquipes() : Int {

	#(CacadoresBug)
}

//Retornar os caçadores de bug responsáveis pelos projetos de um determinado cliente
fun cacadoresBugPorCliente(c:Cliente): set CacadoresBug {

	~bugParaConserto[c.projeto.bugProjeto]
}

//Retornar os dias de trabalho de uma equipe
fun getDiasEquipe(cb:CacadoresBug): set Dia{

	diaTrabalho[bugParaConserto[cb]]
}

//Retornar os projetos de um cliente
fun projetosDoCliente(c:Cliente): set Projeto {

	c.projeto
}

/*----------------------------------------------------------------------------------------------------------------------------------
							OPERAÇÕES
----------------------------------------------------------------------------------------------------------------------------------*/

//Adicionar um outro projeto a um cliente específico
pred adicionarProjetoCliente (c1, c2:Cliente, p:Projeto){
	
	c2.projeto = c1.projeto + p
}

//Remover um determinado projeto de um cliente específico
pred deletarProjetoCliente (c1, c2:Cliente, p:Projeto){

	c2.projeto = c1.projeto - p
}


//Adicionar um bug para ser resolvido por uma equipe de caçadores
pred AdicionarDiasParaResolucaoBug(b1, b2: Bug, d: Dia) {
	
	b2.diaTrabalho = b1.diaTrabalho + d
}
//Adicionar Bug para um equipe de caçadores

pred adicionarBugParaEquipe(e1, e2:CacadoresBug, b:Bug){
	
	e2.bugParaConserto = e1.bugParaConserto + b
}

//Tirar um bug já resolvido
pred darBaixaEmBug(c1, c2: CacadoresBug, b: Bug) {
	
	c2.bugParaConserto = c1.bugParaConserto - b
}
/*----------------------------------------------------------------------------------------------------------------------------------
							ASSERTIONS
----------------------------------------------------------------------------------------------------------------------------------*/

