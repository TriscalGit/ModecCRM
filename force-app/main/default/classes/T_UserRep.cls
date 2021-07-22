/**
* @description       :
* @author            : Hugo Brito
* @group             :
* @last modified on  : 04-23-2021
* @last modified by  : Hugo Brito
* Modifications Log
* Ver   Date         Author       Modification
* 1.0   04-23-2021   Hugo Brito   Criação da classe
**/
public class T_UserRep {
    
	public static User getLoggedUser() { 
    	return [Select id, Profile.UserLicense.Name from User where Id =: UserInfo.getUserId()];
    }
}