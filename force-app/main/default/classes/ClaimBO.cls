public with sharing class ClaimBO {

    private static final ClaimBO instance = new ClaimBO();

	public static ClaimBO getInstance() {
		return instance;
    }

    public void calculateDollar (List<Claim__c> lstClaim)
    {
        Double actualDollar = Double.valueOf(Label.ActualDollar);

        for(Claim__c claim : lstClaim)
        {
            if(claim.AmountUnderDisputeBRL__c == null)
                claim.AmountUnderDisputeBRL__c = 0;
            
            if(claim.AmountUnderDisputeUSD__c == null)
                claim.AmountUnderDisputeUSD__c = 0;

            if(claim.ResultsBRL__c == null)
                claim.ResultsBRL__c = 0;
            
            if(claim.ResultsUSD__c == null)
                claim.ResultsUSD__c = 0;

            if(claim.TotalAmountBRL__c == null)
                claim.TotalAmountBRL__c = 0;
            
            if(claim.TotalAmountUSD__c == null)
                claim.TotalAmountUSD__c = 0;                

            claim.AmountUnderDisputeSum__c = (claim.AmountUnderDisputeBRL__c/actualDollar) + claim.AmountUnderDisputeUSD__c;
            claim.ResultsSum__c = (claim.ResultsBRL__c/actualDollar) + claim.ResultsUSD__c;
            claim.TotalAmountSum__c = (claim.TotalAmountBRL__c/actualDollar) + claim.TotalAmountUSD__c;
        }
    }

    public void fillLetterGroup(List<Claim__c> lstClaim)
    {
        List<Letter__c> lstLetter = new List<Letter__c>();
        String idLetter;
        String idLetterGroup;

        for(Claim__c claim : lstClaim)
        {
            if(claim.Source__c == 'Letter' && claim.Letter__c != null)
            {
                idLetter = claim.Letter__c;
            }
            else 
            {
                return;    
            }
        }

        lstLetter = LetterDAO.getLetterById(idLetter);

        if(!lstLetter.isEmpty())
        {
            for(Letter__c letter : lstLetter)
            {
                if(letter.LetterGroup__c != null)
                {
                    idLetterGroup = letter.LetterGroup__c;

                    for(Claim__c claim : lstClaim)
                    {
                        claim.LetterGroup__c = idLetterGroup;
                    }
                }
            }
        }
    }

    public void createRDOAssociation(List<Claim__c> lstClaim)
    {
        Claim__c claimInstance = new Claim__c();

        claimInstance = lstClaim[0];

        if(claimInstance.Source__c != 'RDO')
        {
            return;
        }
        else
        {
            ClaimRDOAssociation__c claimRDOAssoc = new ClaimRDOAssociation__c();
            claimRDOAssoc.Claim__c = claimInstance.Id;
            claimRDOAssoc.RDO__c = claimInstance.RDO__c;

            insert claimRDOAssoc;
        }
    }
}