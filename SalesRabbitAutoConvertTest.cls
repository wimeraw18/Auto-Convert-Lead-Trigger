@isTest
private class SalesRabbitAutoConvertTest {
    @isTest static void salesRabbitLead() {
        // Create Lead
        Lead myLead = new Lead();
        myLead.Company = 'SR Test';
        myLead.Status = 'New';
        myLead.LastName = 'Test';
        myLead.Energy_Consultant__c = 'Aaron Godwin';
        myLead.SDR__c = 'Cort Howard';
        myLead.LeadSource = 'SalesRabbit';
        myLead.SalesRabbit_Notes__c = 'SalesRabbit notes are here';
        myLead.SalesRabbit_Created_Date__c = Datetime.now();
        myLead.Initial_Appt_Date__c = Datetime.now();
        insert myLead;

        // Get auto converted opportunity
        Opportunity myOpp = [
            SELECT Id
              FROM Opportunity
             WHERE Name = 'SR Test'
             LIMIT 1
        ];

        // check that the event has been created
        Event myEvent = [
            SELECT Id, Subject, StartDateTime, EndDateTime, Description
              FROM Event
             WHERE WhatId = :myOpp.Id
             LIMIT 1
        ];

        System.assertEquals('Demo - SR Test', myEvent.Subject);
        System.assertEquals(myLead.Initial_Appt_Date__c, myEvent.StartDateTime);
        System.assertEquals(myLead.Initial_Appt_Date__c, myEvent.EndDateTime);
        System.assertEquals(myLead.SalesRabbit_Notes__c, myEvent.Description);
    }
}