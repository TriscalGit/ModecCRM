public class T_WarningEmailAlertToSupplierInvocable {

    @InvocableMethod(label='T_WarningEmailAlertToSupplierInvocable' description='Send email to supplier about this warning')
    public static void warningEmailAlertToSuppliers(List<TOBJ_Warning__c> warnings) {
        Set<String> warningIds = T_Utils.getSetIds(warnings, 'Id');
        T_WarningApp.warningEmailAlertToSuppliers(warningIds);
    }
}