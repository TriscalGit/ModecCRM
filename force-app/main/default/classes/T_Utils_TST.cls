/**
 * @description       :
 * @author            : Gabriel Uchôa
 * @group             :
 * @last modified on  : 24-02-2021
 * @last modified by  : Gabriel Uchôa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   24-02-2021   Gabriel Uchôa   Initial Version
 **/

@isTest
public class T_Utils_TST {
    
    @isTest
    public static void TestMethod_getSetIds(){
        List<User> usuarios = [select id, profileId from User limit 20];
        T_Utils.getSetIds(usuarios, 'Id');
    }

    @isTest
    public static void TestMethod_montaMapaListaSObjectComCampoComoChave(){
        List<User> usuarios = [select id, profileId from User limit 20];
        T_Utils.montaMapaListaSObjectComCampoComoChave('profileId', usuarios);
    }
    
    @isTest
    public static void TestMethod_montaMapaSObjectComCampoComoChave(){
        List<User> usuarios = [select id, profileId from User limit 20];
        T_Utils.montaMapaSObjectComCampoComoChave('profileId', usuarios);
    }
    
}