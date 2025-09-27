@IsTest
private class MyUnsplashAssetsControllerTest {
	@IsTest
	static void returnsImagesForTypeImage() {
		Test.startTest();
		List<Map<String,String>> imgs = MyUnsplashAssetsController.getAssets('inst1', 'IMAGE');
		Test.stopTest();
		System.assert(imgs != null && imgs.size() > 0);
		System.assert(imgs[0].containsKey('url'));
	}

	@IsTest
	static void returnsAudioAndVideoForTypes() {
		List<Map<String,String>> aud = MyUnsplashAssetsController.getAssets('inst2', 'AUDIO');
		List<Map<String,String>> vid = MyUnsplashAssetsController.getAssets('inst3', 'VIDEO');
		System.assert(aud != null && aud.size() > 0);
		System.assert(vid != null && vid.size() > 0);
	}
}


