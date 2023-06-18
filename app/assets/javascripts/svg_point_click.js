window.onload = () => {
    const items = document.getElementsByClassName('point_click');
    const point_show_path = 'admin/points/';

    for (let i = 0; i < items.length; i++) {
        items[i].addEventListener('click', function (event) {
            let base_url = new URL(point_show_path, window.location.origin)
            let point_url = new URL(this.getAttribute('id'), base_url)
            window.location.replace(point_url);
        });
    }
}