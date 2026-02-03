let inventoryData = {items: [], weight: 0, maxWeight: 50};

window.addEventListener('message', function(event) {
    if (event.data.type === "openInventory") {
        document.getElementById('inventory-menu').style.display = 'block';
    } else if (event.data.type === "updateInventory") {
        inventoryData = event.data;
        renderInventory();
    }
});

function renderInventory() {
    const container = document.getElementById('items');
    container.innerHTML = '';
    
    if (inventoryData.items.length === 0) {
        container.innerHTML = '<p style="color: #999; grid-column: 1/-1;">Envanter boş</p>';
        return;
    }
    
    inventoryData.items.forEach(item => {
        const div = document.createElement('div');
        div.className = 'item';
        div.innerHTML = `
            <h4>${item.name}</h4>
            <p>Miktar: ${item.count}</p>
            <p style="color: #666; font-size: 10px;">${item.weight.toFixed(1)} kg</p>
        `;
        container.appendChild(div);
    });
    
    // Ağırlık çubuğu güncelle
    const percent = (inventoryData.weight / inventoryData.maxWeight) * 100;
    document.getElementById('weight').innerText = inventoryData.weight.toFixed(1);
    document.getElementById('maxWeight').innerText = inventoryData.maxWeight;
    document.getElementById('weightBar').style.width = Math.min(percent, 100) + '%';
}

function closeInventory() {
    fetch(`https://${GetParentResourceName()}/inventoryAction`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({action: 'close'})
    });
    document.getElementById('inventory-menu').style.display = 'none';
}
