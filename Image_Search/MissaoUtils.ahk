#include <Vis2>


checarImagemGrande(caminho, imagem1, imagem2, imagem3 = false){

    ; existeImagem := clicarSeExistir(caminho, imagem1)
    caminhoImagem := caminho . imagem1
    ImageSearch_Inactive("Hero Zero", caminhoImagem, posicaox, posicaoy)
    ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

    if (!posicaox){
         caminhoImagem := caminho . imagem2
        ImageSearch_Inactive("Hero Zero", caminhoImagem, posicaox, posicaoy)
        ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow
        ; clicarSeExistir(caminho, imagem2)
    }
    if (!posicaox && imagem3){
        caminhoImagem := caminho . imagem3
        ImageSearch_Inactive("Hero Zero", caminhoImagem, posicaox, posicaoy)
        ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow
        ; clicarSeExistir(caminho, imagem3)
    }
    return posicaox
}

esperaOk(caminho) {
    Loop 4 {
        cont += 1
        Sleep, 1000
        existe := clicarSeExistir(caminho, "okay.bmp")

        if (!existe) {
            break
        }
    }
}

clicarSeExistir(caminho, imagem) {
    caminhoImagem := caminho . imagem
    ImageSearch_Inactive("Hero Zero", caminhoImagem, posicaox, posicaoy)
    ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

    return posicaox
}

buscarMelhorMissao(caminho, ByRef totalPagina) {
    setaavancar := true
    paginaMissao := 0
    maiorResultadoMoeda := 0
    maiorResultadoXp := 0

    While setaavancar {
        totalPagina += 1

        esperarImagemClick(caminho, "luta.bmp")

        Sleep, 2000
        minutoEnergia := ocrMinutoEnergia()
        StringSplit, listaMinutoEnergia, minutoEnergia, %A_Space%

        moedaExperiencia := ocrMoedaExperiencia()
        StringSplit, listaMoedaExperiencia, moedaExperiencia, %A_Space%

        paginaMissao := calcularMelhorMissao(listaMoedaExperiencia1, listaMoedaExperiencia2, listaMinutoEnergia2, maiorResultadoMoeda, maiorResultadoXp, paginaMissao, totalPagina)

        ImageSearch_Inactive("Hero Zero", caminho . "fechar.bmp", posicaox, posicaoy)
        ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

        ; clicarSeExistir(caminho, "fechar.bmp")

        setaavancar := false
        Sleep, 1000
        setaavancar := checarImagemGrande(caminho, "setaavancar.bmp", "setaavancargrande.bmp")

    }

    return paginaMissao
}

esperarImagemClick(caminho, imagem) {
    Sleep, 1000
    ImageSearch_Inactive("Hero Zero", caminho . imagem, posicaox, posicaoy)
    ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

    ; clicarSeExistir(caminho, imagem)

    while (!posicaox) {
        Sleep, 300
        ImageSearch_Inactive("Hero Zero", caminho . imagem, posicaox, posicaoy)
        ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow
        ; clicarSeExistir(caminho, imagem)
    }
}

calcularMelhorMissao(moeda, experiencia, energia, ByRef maiorResultadoMoeda, ByRef maiorResultadoXp, ByRef paginaMissao, contadorPagina) {

    resultadoMoeda := moeda / energia
    If (resultadoMoeda > maiorResultadoMoeda) {
        maiorResultadoMoeda := resultadoMoeda
        paginaMissao := contadorPagina
        If (maiorResultadoXp == 0){
            maiorResultadoXp := experiencia / energia
        }
    } else if (resultado == maiorResultadoMoeda) {
        resultadoXp := experiencia / energia
        if (resultadoXp > maiorResultadoXp){
            maiorResultadoXp := resultadoXp
            paginaMissao := contadorPagina
            maiorResultadoMoeda := resultadoMoeda
        }
    }
    return paginaMissao

}

voltarTela(caminho, quantidadeTelasVoltar = False) {
    Sleep, 1000
    setavoltar := true
    
    While (setavoltar) {
        Sleep, 300
        ; setavoltar := False
        setavoltar := checarImagemGrande(caminho, "setavoltar.bmp", "setavoltargrande.bmp", "setavoltarpopup.bmp")
        if (quantidadeTelasVoltar){
            quantidadeTelasVoltar -= 1
            if (quantidadeTelasVoltar == 0){
                break
            }
        }
    }
}

ocrMinutoEnergia() {
    leituraMinutoEnergia := OCR("Hero Zero", "", [222,290,81,58])
    minutoReplaceEnergia := RegExReplace(leituraMinutoEnergia, "[^.0-9\s]", "")
    minutoEnergia := RegExReplace(minutoReplaceEnergia, "\s+", " ")
    return StrReplace(minutoEnergia, ".", "")
}

ocrMoedaExperiencia() {
    leituraMoedaExperiencia := OCR("Hero Zero", "", [454,294,113,56])
    moedaReplaceExperiencia := RegExReplace(leituraMoedaExperiencia, "[^.0-9\s]", "")
    moedaExperiencia := RegExReplace(moedaReplaceExperiencia, "\s+", " ")
    return StrReplace(moedaExperiencia, ".", "")
}

ocrTreinoEnergia(){
    leituraEnergiaTreino := OCR("Hero Zero", "", [225,292,170,44])
    replaceEnergia := RegExReplace(leituraEnergiaTreino, "[^.0-9\s]", "")
    energia := RegExReplace(replaceEnergia, "\s+", " ")
    return StrReplace(energia, ".", "")
}
ocrTreinoPonto(){
    leituraPonto := OCR("Hero Zero", "", [457,351,126,21])
    replacePonto := RegExReplace(leituraPonto, "[^.0-9\s]", "")
    ponto := RegExReplace(replacePonto, "\s+", " ")
    return StrReplace(ponto, ".", "")
}