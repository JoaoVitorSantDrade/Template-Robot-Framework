*** Settings ***
Resource    ../resources/main.resource


*** Variables ***
${email}    joao.andrade@db.tec.br.upc
${senha}    @Chamexmu963


*** Test Cases ***
Feature: User Login
    [Documentation]    Cenário: Login Bem-Sucedido
    Given que eu acesso a página de login
    When eu insiro credenciais válidas    ${email}    ${senha}
    Sleep    10s
    Then devo ver o painel do usuário    ${email}

Feature: Work Items
    [Documentation]    Cenário: Ir até página de work items

    Given devo ver o painel do usuário    ${email}
    Then devo ir ate a pagina de workitems

Feature: Baixar PDF
    [Documentation]    Cenário: Extrair os dados da tabela do site, ir em cada item e baixar seu PDF
    Given devo ver a pagina de Work Items
    Then devo extrair todas as paginas
