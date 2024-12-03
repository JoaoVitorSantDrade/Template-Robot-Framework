*** Settings ***
Resource    acme.robot
Resource    ../resources/main.resource


*** Keywords ***
que eu acesso a página de login
    Abrir o Site

eu insiro credenciais válidas
    [Arguments]    ${USERNAME}    ${PASSWORD}
    Logon    ${USERNAME}    ${PASSWORD}

devo ver o painel do usuário
    [Arguments]    ${USERNAME}
    Carregar Site    ${USERNAME}

devo ver a pagina de ${PAGINA}
    Ler título da pagina    ${PAGINA}

devo ir ate a pagina de workitems
    Ir ate Work Items

devo avancar ${NUMERO} pagina(s)
    FOR    ${NUMERODAPAGINA}    IN RANGE    ${NUMERO}
        Avancar Pagina
    END

devo retroceder ${NUMERO} pagina(s)
    FOR    ${NUMERODAPAGINA}    IN RANGE    ${NUMERO}
        Retroceder Pagina
    END

devo extrair todas as paginas
    [Documentation]    Extrai os dados das paginas e baixa seus PDFs
    ${NUMERO}=    Ler número maximo de paginas
    Log    Tipo de dado: ${NUMERO} é ${NUMERO.__class__.__name__}
    ${todas_as_paginas}=    Create List

    FOR    ${NUMERODAPAGINA}    IN RANGE    ${NUMERO -1}
        ${lista_de_itens}=    Extrair Dados da Tabela
        devo avancar 1 pagina(s)
        Append To List    ${todas_as_paginas}    ${lista_de_itens[0]}
    END

    FOR    ${item_da_lista}    IN    ${todas_as_paginas}
        Abrir PDF em nova Aba    ${item_da_lista}
    END
