public with sharing class EmailTemplateDAO {
	
	public static EmailTemplate getByDeveloperName(String developerName) {
		return [
			SELECT
				Id,
				Name,
				DeveloperName
			FROM
				EmailTemplate
			WHERE
				DeveloperName = :developerName
			LIMIT 1
		];
	}
}