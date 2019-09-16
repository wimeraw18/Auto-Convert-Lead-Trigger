trigger SalesRabbitAutoConvert on Lead (after insert) {
    List<Lead> leadsToConvert = new List<Lead>();
    List<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();

    // 1. add all incoming leads that are from SalesRabbit to a list
    for (Lead myLead: Trigger.new) {
        if (myLead.LeadSource == 'SalesRabbit' && myLead.Initial_Appt_Date__c != null) {
            leadsToConvert.add(myLead);
        }
    }

    // 2. loop through the list and add them to the Database.LeadConvert list
    if (!leadsToConvert.isEmpty()) {
        for (Lead lc : leadsToConvert) {
            // convert Lead
            Database.LeadConvert lcc = new Database.LeadConvert();
            lcc.setLeadId(lc.id);

            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            lcc.setConvertedStatus(convertStatus.MasterLabel);
            leadConverts.add(lcc);
        }
    }

    // 3. Convert all leads in bulk
    if (!leadConverts.isEmpty()) {
            Database.convertLead(leadConverts);
    }
}
