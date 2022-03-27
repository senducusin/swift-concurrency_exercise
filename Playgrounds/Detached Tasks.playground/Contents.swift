import UIKit

func fetchThumbnails() async -> [UIImage] {
    return [UIImage()]
}

func updateUI() async {
    let thumbnails = await fetchThumbnails()
    
    Task.detached(priority: .background) {
        writeToCache(images: thumbnails)
    }
}

private func writeToCache(images: [UIImage]) {
    
}

Task {
    await updateUI()
}
