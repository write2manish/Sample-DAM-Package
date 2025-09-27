public with sharing class MyUnsplashAssetsController {

    public MyUnsplashAssetsController() {

    }

    @AuraEnabled
   public static List<Map<String, String>> getAssets(String instanceKey, String mediaType) {
 
         System.debug('mediaType: '+mediaType);
         System.debug('instanceKey: '+instanceKey);

        Map<String, List<Map<String, String>>>  asserts = 
            new Map<String, List<Map<String, String>>> 
        	{
            'AUDIO'=> new List<Map<String, String>>{ 
                new Map<String, String>{'id' => 'aud-1',
                'title' => 'Audio 1 : from instanceKey= ' +instanceKey,
                'url' => 'https://dare.wisc.edu/wp-content/uploads/sites/1051/2017/08/CA138clip.mp3'}
                
             },
            'IMAGE'=> new List<Map<String, String>>{
            	new Map<String, String>{'id' =>'img_1',
                    'title'=> 'The Hamptons Chair : from instanceKey= '+instanceKey,
                    'altText'=> 'Modern upholstered armchair with clean lines and neutral fabric in a minimalist setting',
                    'url' => 'https://images.unsplash.com/photo-1501045661006-fcebe0257c3f?q=80&w=800&auto=format&fit=crop',
                    'urlName' => 'chair'
                },
                new Map<String, String>{'id' =>'img_2',
                    'title'=> 'Maplewood Lounger : from instanceKey= '+ instanceKey,
                    'altText'=> 'Comfortable wooden lounger chair with curved backrest and natural wood grain finish',
                    'url' => 'https://images.unsplash.com/photo-1540574163026-643ea20ade25?q=80&w=800&auto=format&fit=crop'
                },
                new Map<String, String>{'id' =>'img_3',
                    'title'=> 'Ciderwood Coffee Table : from instanceKey= '+ instanceKey,
                    'altText'=> 'Rustic wooden coffee table with natural edge and rich wood grain texture',
                    'url' => 'https://images.unsplash.com/photo-1496346075815-d9cf3a4b08a1?q=80&w=800&auto=format&fit=crop',
                    'urlName'=> 'coffee-table'
                },
                new Map<String, String>{'id' =>'img_4',
                    'title'=> 'Cinnamon Stick Lamp : from instanceKey= '+ instanceKey,
                    'altText'=> 'Tall floor lamp with slender wooden base and white fabric shade',
                    'url' => 'https://images.unsplash.com/photo-1713623840285-0c6447ae2d16?q=80&w=800&auto=format&fit=crop'
                },
                new Map<String, String>{'id' =>'img_5',
                    'title'=> 'Autumn Oak Console : from instanceKey= '+ instanceKey,
                    'altText'=> 'Elegant wooden console table with drawers and tapered legs in warm oak finish',
                    'url' => 'https://images.unsplash.com/photo-1521607630287-ee2e81ad3ced?q=80&w=800&auto=format&fit=crop',
                    'urlName'=> 'oak-console'
                },
                new Map<String, String>{'id' =>'img_6',
                    'title'=> 'Savannah Dining Table : from instanceKey= '+ instanceKey,
                    'altText'=> 'Large wooden dining table with sturdy pedestal base and smooth natural finish',
                    'url' => 'https://images.unsplash.com/photo-1519643381401-22c77e60520e?q=80&w=800&auto=format&fit=crop',
                    'urlName'=> 'dining-table'
                }
            },  
            'VIDEO'=> new List<Map<String, String>>{
            	new Map<String, String>{'id' =>'vid_1',
                    'title'=> 'AgentForce for Large Business : from instanceKey= '+instanceKey,
                    'altText'=> 'AgentForce',
                    'url' => 'https://www.youtube.com/embed/bKIRzm1p7N4'
                },
                new Map<String, String>{'id' =>'vid_2',
                    'title'=> 'AI Research Lab : from instanceKey= '+ instanceKey,
                    'altText'=> 'Research Lab',
                    'url' => 'https://www.youtube.com/embed/1Rlr2OxR678',
                    'urlName'=> 'research-lab'
                },
                new Map<String, String>{'id' =>'vid_3',
                    'title'=> 'Multi-Modal AI : from instanceKey= '+ instanceKey,
                    'url' => 'https://www.youtube.com/embed/r98jGdLtO6Q'
                },
                new Map<String, String>{'id' =>'vid_4',
                    'title'=> 'Large Action Modela : from instanceKey= '+ instanceKey,
                    'url' => 'https://www.youtube.com/embed/vlvv4ZehrcY',
                    'urlName'=> 'action-modals'

                },
                new Map<String, String>{'id' =>'vid_5',
                    'title'=> 'AgentForce 2.0 : from instanceKey= '+ instanceKey,
                    'altText'=> 'AgentForce 2.0',
                    'url' => 'https://www.youtube.com/embed/sYHWi-d8h_0',
                    'urlName'=> 'anent-force-2'
                },
                new Map<String, String>{'id' =>'vid_6',
                    'title'=> 'Slack AI : from instanceKey= '+ instanceKey,
                    'url' => 'https://www.youtube.com/embed/FOJc42kUIfI',
                    'urlName'=> 'slack-ai'
                }
            }
        };

        return asserts.get(mediaType);
    }
 
}