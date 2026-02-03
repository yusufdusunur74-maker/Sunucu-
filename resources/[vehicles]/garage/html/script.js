let selectedVehicle = null;
let allVehicles = [];
let currentCategory = "all";

// Menüyü Aç
window.addEventListener('message', function(event) {
    if (event.data.type === "openGarage") {
        document.getElementById('garage-menu').style.display = 'flex';
        allVehicles = event.data.vehicles;
        renderCategories(event.data.categories);
        renderVehicles(event.data.vehicles);
    } else if (event.data.type === "close") {
        document.getElementById('garage-menu').style.display = 'none';
    }
});

function renderCategories(categories) {
    const container = document.getElementById('categories');
    container.innerHTML = '';
    
    categories.forEach(cat => {
        const btn = document.createElement('button');
        btn.className = 'category-btn' + (cat.filter === 'all' ? ' active' : '');
        btn.innerText = cat.name;
        btn.onclick = () => filterVehicles(cat.filter, btn);
        container.appendChild(btn);
    });
}

function renderVehicles(vehicles) {
    const container = document.getElementById('vehicles');
    container.innerHTML = '';
    
    const filtered = currentCategory === 'all' 
        ? vehicles 
        : vehicles.filter(v => v.type === currentCategory);
    
    filtered.forEach(vehicle => {
        const div = document.createElement('div');
        div.className = 'vehicle-item';
        div.innerHTML = `
            <h4>${vehicle.name}</h4>
            <p>$${vehicle.price.toLocaleString('tr-TR')}</p>
            <p style="color: #666; font-size: 10px;">${vehicle.type}</p>
        `;
        div.onclick = () => selectVehicle(vehicle, div);
        container.appendChild(div);
    });
}

function selectVehicle(vehicle, element) {
    selectedVehicle = vehicle;
    document.querySelectorAll('.vehicle-item').forEach(el => el.classList.remove('selected'));
    element.classList.add('selected');
    
    document.getElementById('vehicleInfo').innerHTML = `
        <h4>${vehicle.name}</h4>
        <p><strong>Fiyat:</strong> $${vehicle.price.toLocaleString('tr-TR')}</p>
        <p><strong>Tip:</strong> ${vehicle.type}</p>
        <p><strong>Model:</strong> ${vehicle.model}</p>
        <p style="color: #ffaa00;">Satın almak için aşağıdaki butona tıklayın</p>
    `;
    
    document.getElementById('buyBtn').style.display = 'block';
}

function filterVehicles(category, btn) {
    currentCategory = category;
    renderVehicles(allVehicles);
    document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
}

function buyVehicle() {
    if (selectedVehicle) {
        fetch(`https://${GetParentResourceName()}/garageAction`, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                action: 'buyVehicle',
                vehicleId: selectedVehicle.id
            })
        });
    }
}

window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        closeGarage();
    }
});

function closeGarage() {
    fetch(`https://${GetParentResourceName()}/garageAction`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({action: 'close'})
    });
}

// Button bağlantısı
document.getElementById('buyBtn').addEventListener('click', buyVehicle);
