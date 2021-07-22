public class UserDAO {
	
	public static List<User> getById(Set<Id> setIds) {
		return [SELECT
					Id,
					Name,
					UserRoleId,
					UserRole.DeveloperName,
					UserRole.Name
				FROM
					User
				WHERE
					Id = :setIds];
	}
}