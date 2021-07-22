public class T_WarningApp {

    public static void warningEmailAlertToSuppliers(){
        Database.executeBatch(new T_WarningBatch(), 10);
    }
    
    public static void warningEmailAlertToSuppliers(Set<String> warningIds){
        
        List<TOBJ_Participants__c> participantes = T_ParticipantRep.getParticipantByWarningId(warningIds);
        IF(participantes != null && participantes.size() > 0){
            T_WarningHelper helper = new T_WarningHelper();
            helper.setParticipantes(participantes);
            helper.getContentDocumentLinksForWarnings();
            helper.montarEmailsWarning();
            helper.sendEmails();
            helper.updateParticipantes();
        }
    }
}