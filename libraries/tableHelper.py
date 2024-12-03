from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webdriver import WebDriver
from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.remote.webelement import WebElement

def extract_table_data(table_element:WebElement):
    """
    Extrai os dados da tabela no formato de lista de listas.
    :param table_xpath: XPath para localizar a tabela.
    :return: Lista de listas representando os dados da tabela.
    """

    table_data = []
    linhas = table_element.find_elements(By.TAG_NAME,"tr")
    linhas = linhas[1:] # Retiro os itens do topo (Que são os headers)
    for linha in linhas:
        itens:list[WebElement] = linha.find_elements(By.TAG_NAME,"td")
        if itens:
            itens = itens[1:] # Retira os itens mais a esquerda (Que são os dois botões)
            aux = []
            for item in itens:
                aux.append(item.get_attribute("innerHTML"))
            table_data.append(aux)
    return table_data

