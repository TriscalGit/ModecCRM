({
    sendToSAP : function (cmp, event, helper) {
        cmp.set('v.loaded', false);
        cmp.set('v.disableButton', true);
        cmp.set('v.showMsgList', false);
        //alert("You clicked: " + event.getSource().get("v.label"));
        helper.sendBMtoSAP(cmp);
    }
});