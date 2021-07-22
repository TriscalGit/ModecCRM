({
	doInit: function (component, event, helper) {
		component.set("v.IsSpinner",true);
		helper.CloneInspection(component);
	},

	btnConfirm: function (component, event, helper) {
		$A.get("e.force:closeQuickAction").fire()
	},
})