public with sharing class VORVOBO {
    
    private static final VORVOBO instance = new VORVOBO();

	public static VORVOBO getInstance() {
		return instance;
    }

    public void fillLetterGroup(List<VORVO__c> lstVORVO)
    {
        List<Letter__c> lstLetter = new List<Letter__c>();
        String idLetter;
        String idLetterGroup;

        for(VORVO__c vor : lstVORVO)
        {
            if(vor.Letter__c != null && vor.LetterGroup__c == null)
            {
                idLetter = vor.Letter__c;
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

                    for(VORVO__c vor : lstVORVO)
                    {
                        vor.LetterGroup__c = idLetterGroup;
                    }
                }
            }
        }
    }
}