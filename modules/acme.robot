*** Settings ***
Resource    ../resources/main.resource
Library     ../libraries/tableHelper.py
Library     RPA.PDF


*** Variables ***
${URL}=                 https://acme-test.uipath.com/login
${BROWSER}=             chrome
${CHROME_OPTIONS}       headless    no-sandbox    disable-dev-shm-usage    disable-gpu
${DRIVER}               ${EMPTY}


*** Keywords ***
Set Download Preferences
    [Arguments]    ${options}
    ${prefs}=    Create Dictionary
    ...    download.prompt_for_download=False
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-popup-blocking
    # Call Method    ${options}    add_argument    --headless
    RETURN    ${options}

Abrir o Site
    Log To Console    Abrindo o Navegador ${BROWSER}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${options}=    Set Download Preferences    ${options}
    ${DRIVER}=    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Log To Console    Navegador ${BROWSER} com sucesso

Logon
    [Arguments]    ${USERNAME}    ${PASSWORD}
    Log To Console    Inicio Logon
    Input Text    id:email    ${USERNAME}
    Input Text    id:password    ${PASSWORD}
    Click Button    xpath=/html/body/div/div[2]/div/div/div/form/button
    Log To Console    Fim Logon

Carregar Site
    [Arguments]    ${USERNAME}
    Element Should Be Visible    xpath=//h1/strong[text()='${USERNAME}']

Avancar Pagina
    Click Element    xpath=//li//a[contains(@aria-label, "Next")]

Retroceder Pagina
    Click Element    xpath=//li//a[contains(@aria-label,"Previous")]

Ir ate ${Work Items}
    Click Button    xpath=//button[contains(normalize-space(.), "${Work Items}")]

Ler título da pagina
    [Arguments]    ${titulo}
    Element Should Be Visible    //h1[contains(normalize-space(), '${titulo}')]

Ler número maximo de paginas
    ${page_links}=    Get WebElements    //a[contains(@href, "work-items?page=")]
    ${page_numbers}=    Create List
    FOR    ${link}    IN    @{page_links}
        ${href}=    Get Element Attribute    ${link}    href
        ${number}=    Get Regexp Matches    ${href}    work-items\\?page=(\\d+)    1
        Append To List    ${page_numbers}    ${number[0]}
    END
    ${largest_page}=    Evaluate    max(map(int, ${page_numbers}))
    ${largest_page}=    Convert To Integer    ${largest_page}
    Log    Tipo de dado: ${largest_page} é ${largest_page.__class__.__name__}
    RETURN    ${largest_page}

Extrair Dados da Tabela
    ${table}=    Get WebElement    xpath=//table[@class="table"]
    ${Itens}=    Extract Table Data    ${table}
    RETURN    ${Itens}

Abrir PDF em nova Aba
    [Documentation]    Abre todos os PDFs de uma página
    [Arguments]    ${lista_de_itens}

    FOR    ${linha_de_itens}    IN    @{lista_de_itens}
        Switch Window    MAIN
        Execute Javascript    window.open('')
        Sleep    2s
        Switch Window    NEW
        Go To    https://acme-test.uipath.com/work-items/${linha_de_itens[0]}
        Sleep    3s    Espera página carregar
        Click Element    //button[contains(text(), 'Download Check Request')]
        Sleep    2s    Espera abrir o PDF
        Close Window
        Sleep    1s
    END
