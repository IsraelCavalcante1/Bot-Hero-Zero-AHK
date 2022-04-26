#Include Gdip_ImageSearch.ahk
#Include Gdip_all.ahk
#Include MissaoUtils.ahk
SetBatchLines, -1
SetWorkingDir, %A_WorkingDir%

file=%a_scriptdir%\test.png
caminho=%a_scriptdir%\imagens\
return=

/*
Gdip_ImageSearch(pBitmapHaystack,pBitmapNeedle,ByRef OutputList=""
,OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=""
,SearchDirection=1,Instances=1,LineDelim="`n",CoordDelim=",")
*/



ImageSearch_Inactive(Title, ImgFileName, ByRef vx, ByRef vy ) {
    If !pToken := Gdip_Startup() {
        MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
        ExitApp
    }

    WinGetPos , , , Width, Height, Title
    
    pBitmapHayStack := Gdip_BitmapFromHWND(hwnd := WinExist(Title)) 
    pBitmapNeedle := Gdip_CreateBitmapFromFile(ImgFileName)

    result := Gdip_ImageSearch(pBitmapHayStack,pBitmapNeedle,list,0,0,Width, Height,100,,1,1)

    if (result) {  
        StringSplit, LISTArray, LIST, `,  
        vx:=LISTArray1 
        vy:=LISTArray2
        
        Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
        Gdip_Shutdown(pToken)
        return true
    } else {
        Gdip_DisposeImage(pBitmapHayStack), Gdip_DisposeImage(pBitmapNeedle)
        Gdip_Shutdown(pToken)
        return false
    }
}

; Testes ;
Numpad0::
    while True{
        totalPagina := 0
        voltarTela(caminho)
        paginaMissao := buscarMelhorMissao(caminho, totalPagina)
        quantidadePaginaVoltar := totalPagina - paginamissao
        voltarTela(caminho, quantidadePaginaVoltar)
        esperarImagemClick(caminho, "luta.bmp")
        esperarImagemClick(caminho, "iniciar.bmp")
        esperarImagemClick(caminho, "pular.bmp")
        esperaOk(caminho)
        ImageSearch_Inactive("Hero Zero",caminho . "descontardepois.bmp",posicaox,posicaoy)
        ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow
    }

    return

Numpad2::
    ; ImageSearch_Inactive("Hero Zero",caminho . "treinointuicao.bmp",posicaox,posicaoy)
    ;     posicaoy += 40
    ;     ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow
    ;     msgbox, %posicaox% / %posicaoy%
    while (true) {
        paginaExercicio := 0
        esperarImagemClick(caminho, "lutatreino.bmp")
        maiorResultadoExercicio := 0
        paginaMelhorExercicio := 0
        pontoMaiorExercicio := 0

        ponto1 := 0
        ponto2 := 0
        ponto3 := 0

        Loop 3 {
            paginaExercicio += 1
            Sleep, 1000
            energia := ocrTreinoEnergia()
            ponto := ocrTreinoPonto()

            if (paginaExercicio == 1) {
                ponto1 := ponto
            } else if (paginaExercicio == 2) {
                ponto2 := ponto
            } else {
                ponto3 := ponto
            }

            multiplicaEnergia := energia * 10
            resultado := ponto - multiplicaEnergia

            if (resultado > maiorResultadoExercicio){
                maiorResultadoExercicio := resultado
                pontoMaiorExercicio := ponto
                paginaMelhorExercicio := paginaExercicio
            } else if (resultado == maiorResultadoExercicio && ponto > pontoMaiorExercicio) {
                    maiorResultadoExercicio := resultado
                    pontoMaiorExercicio := ponto
                    paginaMelhorExercicio := paginaExercicio
            }

            setaavancar := checarImagemGrande(caminho, "setaavancartreino.bmp", "setaavancartreinogrande.bmp", "setaavancartreinopopup.bmp")
        }

        if (maiorResultadoExercicio == 10) {
            if (ponto1 < maiorResultadoExercicio) {
                paginaMelhorExercicio := 1
            } else if (ponto2 < maiorResultadoExercicio) {
                paginaMelhorExercicio := 2
             }else {
                paginaMelhorExercicio := 3
            }
        }

        MsgBox, "Voltar" . %paginaMelhorExercicio%

        loop paginaMelhorExercicio {
            setaavancar := checarImagemGrande(caminho, "setaavancartreino.bmp", "setaavancartreinogrande.bmp", "setaavancartreinopopup.bmp")
        }

        MsgBox, "achou o melhor" . %paginaMelhorExercicio% . "valor: " . %pontoMaiorExercicio%

        ImageSearch_Inactive("Hero Zero",caminho . "completo.bmp",posicaox,posicaoy)
        ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

        sleep, 1000

        ImageSearch_Inactive("Hero Zero",caminho . "ficousemgas.bmp",ficousemgasx,ficousemgasy)
        ControlClick, x%ficousemgasx% y%ficousemgasy%, ahk_class ApolloRuntimeContentWindow

        if (ficousemgas) {
            sleep, 1000
            ImageSearch_Inactive("Hero Zero", caminho . "fechar.bmp", posicaox, posicaoy)
            ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

            sleep, 1000
            ImageSearch_Inactive("Hero Zero", caminho . "fechar.bmp", posicaox, posicaoy)
            ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow
        } else {
            sleep, 1000

            ImageSearch_Inactive("Hero Zero",caminho . "pulartreino.bmp",posicaox,posicaoy)
            ControlClick, x%posicaox% y%posicaoy%, ahk_class ApolloRuntimeContentWindow

            esperaOk(caminho)
        }

        msgbox, "cabou" . %paginaMelhorExercicio%
    }
      















; WinActivate, ahk_class ApolloRuntimeContentWindow
; Sleep, 2000
; WinMove, ahk_class ApolloRuntimeContentWindow, , 0, 0 , 300, 300

; ; Clicar no Login
; ImageSearch_Inactive("Hero Zero",caminho . "login.bmp",loginx,loginy)
; Sleep, 2000
; SetMouseDelay, 3000
; ControlClick, x%loginx% y%loginy%, ahk_class ApolloRuntimeContentWindow
; Sleep, 2000

; ; Clicar no Email e digita-lo
; ImageSearch_Inactive("Hero Zero",caminho . "email.bmp",emailx,emaily)
; emailx += 150
; SetMouseDelay, 3
; ControlClick, x%emailx% y%emaily%, ahk_class ApolloRuntimeContentWindow2
; Sleep, 3000
; SetKeyDelay, 10, 30
; ControlSend,, leopontorua@gmail.com, ahk_class ApolloRuntimeContentWindow
; Sleep, 3000
; ; Clicar na senha e digita-la

; ImageSearch_Inactive("Hero Zero",caminho . "senha.bmp",senhax,senhay)
; senhax += 150
; ControlClick, x%senhax% y%senhay%, ahk_class ApolloRuntimeContentWindow
; Sleep, 3000
; ControlSend,,25023, ahk_class ApolloRuntimeContentWindow
; Sleep, 3000

; ; Clicar no botão entrar
; ImageSearch_Inactive("Hero Zero",caminho . "entrar.bmp",entrarx,entrary)
; ControlClick, x%entrarx% y%entrary%, ahk_class ApolloRuntimeContentWindow
; return


; Sleep, 3000
; ImageSearch_Inactive("Hero Zero",caminho . "missao.bmp",telamissaox,telamissaoy)
; ControlClick, x%telamissaox% y%telamissaoy%, ahk_class ApolloRuntimeContentWindow
; Sleep, 3000
; 




; ; f2::
; ; ; WinKill, ahk_class ApolloRuntimeContentWindow
; ; ExitApp