#INCLUDE "TOTVS.CH"


USER FUNCTION M460FIM()

    Local aAreaAtu := GetArea()
    Local aAreaSC6 := SC6->(GetArea())
    Local aAreaSC5 := SC5->(GetArea())
    Local lGeraReg := .T.

    SC6->(dbSetOrder(4))
    If SC6->(msSeek(xFilial("SC6") + SF2->(F2_DOC + F2_SERIE)))
        SC5->(dbSetOrder(1))
        If SC5->(msSeek(SC6->(C6_FILIAL + C6_NUM)))

            Z01->(dbSetOrder(1))
            If Z01->(dbSeek(SC5->(C5_FILIAL + C5_NUM)))
                
                While Z01->(!EOF()) .and. Z01->(Z01_FILIAL + Z01_C5_NUM) == SC5->(C5_FILIAL + C5_NUM) .and. lGeraReg == .T.

                    If Empty(Z01->Z01_F2_DOC)

                        RECLOCK("Z01", .F.)
                    
                            Z01_F2_DOC := SF2->F2_DOC
                            Z01_F2_SER := SF2->F2_SERIE
                            Z01_VALBRU := SF2->F2_VALBRUT
                            Z01_EMISSA := SF2->F2_EMISSAO
                            Z01_DTNOTA := FWTimeStamp(2, SF2->F2_EMISSAO, SF2->F2_HORA + ":00")
                            Z01_USRNOT := UsrFullName(RetCodUsr())
                            Z01_CHVNFE := SF2->F2_CHVNFE
                            Z01_CANCNF := "A"
                        
                        Z01->(MSUNLOCK())

                        lGeraReg := .F.
                        //Exit
                
                    EndIf

                    Z01->(dbSkip())
                EndDo

                If lGeraReg == .T.

                    RECLOCK("Z01", .T.)
            
                        Z01_FILIAL := SC5->C5_FILIAL
                        Z01_SGACSO := SC5->C5_XSGACSO
                        Z01_OSSGAC := SC5->C5_XOSSGAC
                        Z01_C5_NUM := SC5->C5_NUM
                        Z01_M0_CGC := POSICIONE("SM0", 1, cEmpAnt + cFilAnt, "M0_CGC")
                        Z01_A1_CGC := POSICIONE("SA1", 1, xFilial("SA1") + SC5->(C5_CLIENTE + C5_LOJACLI), "A1_CGC")
                        Z01_C5_EMI := SC5->C5_EMISSAO
                        Z01_DTPEDI := FWTimeStamp(2, SC5->C5_EMISSAO, TIME()) 

                        Z01_F2_DOC := SF2->F2_DOC
                        Z01_F2_SER := SF2->F2_SERIE
                        Z01_VALBRU := SF2->F2_VALBRUT
                        Z01_EMISSA := SF2->F2_EMISSAO
                        Z01_DTNOTA := FWTimeStamp(2, SF2->F2_EMISSAO, SF2->F2_HORA + ":00")
                        Z01_USRNOT := UsrFullName(RetCodUsr())
                        Z01_CHVNFE := SF2->F2_CHVNFE
                        Z01_CANCNF := "A"
                    
                    Z01->(MSUNLOCK())
                
                EndIf
                
            EndIf

        EndIf
    EndIf

    RestArea(aAreaSC6)
    RestArea(aAreaSC5)
    RestArea(aAreaAtu)

RETURN
