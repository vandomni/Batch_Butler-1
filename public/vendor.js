function viewInventory(id){
	$.ajax({
		url: '/vendor_inventory' + id,
		type: 'PUT',
		data: $('#view_inventory').serialize(),
		success: function(result){
			window.location.replace("./");
		}
	})
};