# Introduction

Journals production identified a need for the ability to delete content from OJS. This happened for two reasons:

1. When an **issue** is deleted in OJS, all of the articles within that issue are returned to the review process under the label **unassigned**. This is problematic because, for the most part, these articles were never even part of the review process in the first place. 
2. Deleting articles from this list requires the user to go into the *Summary* for each article and "Reject and Archive" each article. *Each* article. 

So, Jen Whitney developed this bookmarklet and java plugin that provides the user with a list of IDs so they can run **deleteSubmissions.php** in the OJS tools directory. This is the *only way* to delete articles from OJS permanently. 

# Workflow

1. Open the **Unassigned** articles in the **Editor** section. 
2. Click the bookmarklet. 
3. On the right, you'll see a new block with a list of IDs. 
4. Via command line, go to the document root of the journals site (``/var/www/journals.lib.unb.ca/htdocs``). 
5. Run ``>php tools/deleteSubmissions.php`` after pasting in your list of IDs.  
6. Feel smug and fresh having deleted your unnecessary cruft. 
