(function() {
  
  var Widget = function(id) {
    // Create block 
    this.block = document.createElement("div");
    this.block.id = id;
    this.block.className = 'block';
    
    // the HTML we're interested in
    var listingTables = [];
    var regexp = new RegExp('\\b' + 'listing' + '\\b');
    var allTables = document.getElementsByTagName('body')[0].getElementsByTagName('table');
    for (var i=0, j=allTables.length; i<j; i++) {
      if (regexp.test(allTables[i].className)) {
        listingTables.push(allTables[i]);
      }
    }	

    var submissionsTable = listingTables[0];

    // push article IDs onto array
    var articleIds = new Array();
    
    // skip header rows (index 0 & 1): template places these in <tbody> 
    // skip final rows (index )
    for (rowIndex = 2; rowIndex < (submissionsTable.rows.length - 1); rowIndex++) {
      if (submissionsTable.rows[rowIndex].cells.length > 1) {
        articleIds.push(submissionsTable.rows[rowIndex].cells[0].innerHTML);
      }
    }

    this.block.innerHTML = 
      '<span class="blockTitle">Submission ID List</span>' +
      '<p>' + articleIds.join(' ') +  '</p>' + 
      '<p>[ <a href="#">hide</a> ]</p>';

    var that = this;

    // Next action: make it go away
    this.block.lastChild.onclick = function() { 
      that.block.style.display = "none"; 
    };
  };

  function main() {
    var widgetId = "bookmarkletWidget";
    var widget = new Widget(widgetId);
    document.getElementById('rightSidebar').insertBefore(widget.block, document.getElementById('sidebarUser'));
  }
  
  main();
})();





