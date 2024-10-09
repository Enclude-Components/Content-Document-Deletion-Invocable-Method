/**
 * @description     Tests ContentDocumentDeletionInvocable.cls
 */
@SuppressWarnings('PMD.MethodNamingConventions')
@IsTest
public class ContentDocumentDeletionInvocable_TEST {

    @IsTest
    public static void deleteContentDocuments() {
        // Create a test record
        Task testTask = new Task(Subject = 'Test Task', Status = 'Not Started', Priority = 'Normal');
        insert testTask;

        // Create a ContentDocument and link it to the test Task
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test Data'),
            IsMajorVersion = true
        );
        insert contentVersion;

        // Get the ContentDocument from the ContentVersion
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;

        // Link ContentDocument to the test Task
        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = testTask.Id,
            ContentDocumentId = contentDocumentId,
            ShareType = 'I'
        );
        insert contentLink;

        // Prepare the input parameter for the invocable method
        ContentDocumentDeletionInvocable.ContentDocumentDeletionParams param = new ContentDocumentDeletionInvocable.ContentDocumentDeletionParams();
        param.recordIds = new Id[] { testTask.Id };
        
        ContentDocumentDeletionInvocable.ContentDocumentDeletionParams[] paramsList = new List<ContentDocumentDeletionInvocable.ContentDocumentDeletionParams>();
        paramsList.add(param);

        // Call the Invocable method
        Test.startTest();
        ContentDocumentDeletionInvocable.deleteContentDocuments(paramsList);
        Test.stopTest();

        // Assert that the ContentDocument was deleted
        ContentDocumentLink[] deletedLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :testTask.Id];
        System.assertEquals(0, deletedLinks.size(), 'ContentDocumentLink should be deleted.');

        ContentDocument[] deletedDocs = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId];
        System.assertEquals(0, deletedDocs.size(), 'ContentDocument should be deleted.');
    }
    
    @isTest
    public static void deleteContentDocuments_NullRecordIds() {
        // Test scenario where recordIds is null
        ContentDocumentDeletionInvocable.ContentDocumentDeletionParams param = new ContentDocumentDeletionInvocable.ContentDocumentDeletionParams();
        param.recordIds = null;

        ContentDocumentDeletionInvocable.ContentDocumentDeletionParams[] paramsList = new List<ContentDocumentDeletionInvocable.ContentDocumentDeletionParams>();
        paramsList.add(param);

        // Call the Invocable method
        Test.startTest();
        Exception caughtException;
        try {
            ContentDocumentDeletionInvocable.deleteContentDocuments(paramsList);
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertEquals(
            null,
            caughtException,
            'ContentDocumentDeletionInvocable.deleteContentDocuments should not throw an exception when passed null data'
        );
    }

    @isTest
    public static void deleteContentDocuments_EmptyRecordIds() {
        // Test scenario where recordIds is empty
        ContentDocumentDeletionInvocable.ContentDocumentDeletionParams param = new ContentDocumentDeletionInvocable.ContentDocumentDeletionParams();
        param.recordIds = new Id[] {}; // Empty list

        ContentDocumentDeletionInvocable.ContentDocumentDeletionParams[] paramsList = new List<ContentDocumentDeletionInvocable.ContentDocumentDeletionParams>();
        paramsList.add(param);

        // Call the Invocable method
        Test.startTest();
        Exception caughtException;
        try {
            ContentDocumentDeletionInvocable.deleteContentDocuments(paramsList);
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertEquals(
            null,
            caughtException,
            'ContentDocumentDeletionInvocable.deleteContentDocuments should not throw an exception when passed empty data'
        );
    }

}