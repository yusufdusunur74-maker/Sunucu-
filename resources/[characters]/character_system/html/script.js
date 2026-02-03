window.addEventListener('message', function(event){
  const item = event.data;
  if(item.type === 'openChars'){
    const list = item.list || [];
    const container = document.getElementById('list');
    container.innerHTML = '';
    list.forEach((c, i) =>{
      const el = document.createElement('div');
      el.style.display = 'flex';
      el.style.justifyContent = 'space-between';
      el.style.alignItems = 'center';
      el.style.padding = '6px';
      el.style.border = '1px solid #ddd';
      el.innerHTML = `
        <div>
          <b>${c.name || ('Karakter '+(i+1))}</b><br>
          <small>Yüz: ${c.face || '-'} • Saç: ${c.hair || '-'} • Kilo: ${c.weight || '-'}</small>
        </div>
        <div style="display:flex; gap:6px;">
          <button onclick="select(${i})">Seç</button>
          <button onclick="renamePrompt(${i})">Yeniden Adlandır</button>
          <button onclick="deleteChar(${i})">Sil</button>
        </div>
      `;
      container.appendChild(el);
    });
  }
});

function createChar(){
  const data = {
    name: document.getElementById('name').value || ('Oyuncu'),
    face: parseInt(document.getElementById('face').value) || 1,
    hair: parseInt(document.getElementById('hair').value) || 1,
    weight: parseInt(document.getElementById('weight').value) || 70
  };
  fetch(`https://${GetParentResourceName()}/createCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  });
}

function select(index){
  fetch(`https://${GetParentResourceName()}/selectCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({index: index})
  });
}

function previewChar(){
  const data = {
    name: document.getElementById('name').value || ('Oyuncu'),
    face: parseInt(document.getElementById('face').value) || 1,
    hair: parseInt(document.getElementById('hair').value) || 1,
    weight: parseInt(document.getElementById('weight').value) || 70
  };
  fetch(`https://${GetParentResourceName()}/previewCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  });
}

function deleteChar(index){
  if(!confirm('Karakteri silmek istediğinize emin misiniz?')) return;
  fetch(`https://${GetParentResourceName()}/deleteCharacter`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({index: index})
  });
}

function renamePrompt(index){
  const newName = prompt('Yeni isim:');
  if(newName && newName.trim().length > 0){
    fetch(`https://${GetParentResourceName()}/renameCharacter`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({index: index, name: newName.trim()})
    });
  }
}
