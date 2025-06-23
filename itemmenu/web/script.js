let allItems = [];

document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('searchInput');

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (data.type === 'setItems') {
            allItems = data.items.sort((a, b) => a.label.localeCompare(b.label));
            displayItems(allItems);
        } else if (data.action === "openUI") {
            openUI();
        }
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') closeUI();
    });

    searchInput.addEventListener('input', (e) => {
        const searchTerm = e.target.value.toLowerCase();
        const filteredItems = allItems.filter(item =>
            item.name.toLowerCase().includes(searchTerm) ||
            item.label.toLowerCase().includes(searchTerm)
        );
        displayItems(filteredItems);
    });
});

function openUI() {
    document.body.style.display = 'block';
}

function closeUI() {
    document.body.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: 'POST' });
}

function displayItems(items) {
    const itemList = document.getElementById('item-list');
    itemList.innerHTML = '';
    document.getElementById('results-count').textContent = `${items.length} items found`;

    items.forEach(item => {
        const card = document.createElement('div');
        card.className = 'item-card';
        // QUAN TRỌNG: Đường dẫn hình ảnh được trỏ tới qb-inventory
        const imageUrl = `nui://qb-inventory/html/images/${item.name}.png`;

        card.innerHTML = `
            <div class="item-image-container">
                <img src="${imageUrl}" class="item-image" alt="${item.label}" onerror="this.src='https://i.imgur.com/PsmK22o.png'">
            </div>
            <div class="item-content">
                <div class="item-label">${item.label}</div>
                <div class="item-name">${item.name}</div>
                <div class="item-actions">
                    <input type="number" class="amount-input" id="amount-${item.name}" value="1" min="1">
                    <button class="spawn-btn" onclick="spawnItem('${item.name}')">
                        <i class="fas fa-plus"></i> Spawn
                    </button>
                </div>
            </div>
        `;
        itemList.appendChild(card);
    });
}

function spawnItem(itemName) {
    const amountInput = document.getElementById(`amount-${itemName}`);
    const amount = amountInput.value;

    if (amount && parseInt(amount) > 0) {
        fetch(`https://${GetParentResourceName()}/spawnItem`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                itemName: itemName,
                amount: amount
            }),
        });
        closeUI();
    }
}