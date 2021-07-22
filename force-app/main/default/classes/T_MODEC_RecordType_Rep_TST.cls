@isTest
public class T_MODEC_RecordType_Rep_TST {

    @isTest
    Public static void TestMethod_GetVendorNotHomologRecType(){
        T_MODEC_RecordType_Rep rep = new T_MODEC_RecordType_Rep();
        RecordType rt = rep.GetVendorNotHomologRecType();
        System.assertEquals('TW1_Vendor_Not_Homologated', rt.DeveloperName);
    }
    
    @isTest
    Public static void TestMethod_getCategoryRecordTypes(){
        List<RecordType> rts = T_MODEC_RecordType_Rep.getCategoryRecordTypes();
    }
}