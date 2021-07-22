public class VesselContactDAO {
	
	public static List<VesselContact__c> getByVesselId(Set<String> setVesselIds) {
		return [SELECT
					Id,
					Contact__c,
					Vessel__c
				FROM
					VesselContact__c
				WHERE
					Vessel__c IN :setVesselIds
				AND PdfAlert__c = true];
	}
}