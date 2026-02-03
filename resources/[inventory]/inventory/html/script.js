// Minimal placeholder for future NUI
console.log('Inventory UI loaded (stub)')
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
        // Minimal placeholder for future NUI
        console.log('Inventory UI loaded (stub)')
        let inventoryData = {items: [], weight: 0, maxWeight: 50};

        window.addEventListener('message', function(event) {
            if (event.data.type === "openInventory") {
                document.getElementById('inventory-menu').style.display = 'block';
            } else if (event.data.type === "updateInventory") {
                inventoryData = event.data;
                renderInventory();
            } else if (event.data.type === 'openTrunkUI') {
                inventoryData = {items: event.data.data.items || [], weight: 0, maxWeight: 999}
                renderInventory('trunk', event.data.data)
            } else if (event.data.type === 'openStashUI') {
                inventoryData = {items: event.data.data.items || [], weight: 0, maxWeight: 999}
                renderInventory('stash', event.data.data)
            }
        });

        function renderInventory(mode = 'inventory', meta = {}) {
            const container = document.getElementById('items');
            container.innerHTML = '';
    
            if (inventoryData.items.length === 0) {
                container.innerHTML = '<p style="color: #999; grid-column: 1/-1;">Envanter boş</p>';
                return;
            }
    
            inventoryData.items.forEach(item => {
                const div = document.createElement('div');
                div.className = 'item';
                const weightText = item.weight ? (item.weight.toFixed(1) + ' kg') : '';
                div.innerHTML = `
                    <h4>${item.name}</h4>
                    <p>Miktar: ${item.count}</p>
                    <p style="color: #666; font-size: 10px;">${weightText}</p>
                    <div class="item-actions">
                        <button onclick="useItem('${item.name}')">Kullan</button>
                        <button onclick="dropItem('${item.name}')">Bırak</button>
                        ${mode === 'trunk' ? `<button onclick="trunkWithdraw('${meta.plate||''}','${item.name}')">Al</button>` : ''}
                        ${mode === 'stash' ? `<button onclick="stashWithdraw('${meta.id||''}','${item.name}')">Al</button>` : ''}
                    </div>
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

        function postAction(action, payload) {
            fetch(`https://${GetParentResourceName()}/inventoryAction`, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(Object.assign({action: action}, payload || {}))
            });
        }

        function useItem(name) { postAction('useItem', {item: {name: name}}) }
        function dropItem(name) { postAction('dropItem', {itemName: name, count: 1}) }
        function trunkWithdraw(plate, name) { postAction('trunkWithdraw', {plate: plate, itemName: name, count: 1}) }
        function stashWithdraw(id, name) { postAction('stashWithdraw', {stashId: id, itemName: name, count: 1}) }

        // Basit bildirim işleme (sunucudan gönderilen mesajları göster)
        window.addEventListener('message', function(event) {
            if (event.data && event.data.type === 'notification') {
                const msg = event.data.message || '';
                // Basit: alert kullanıyoruz; isterseniz NUI içinde toast/uzantı ekleyebilirsiniz
                alert(msg);
            }
        });
