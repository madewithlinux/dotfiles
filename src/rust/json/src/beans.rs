use std::collections::BTreeMap;

#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct LocalData {
	pub groupsByName: BTreeMap<String, Group>,
	pub messages: Vec<Message>,
}


#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct Group {
	pub id: String,
	pub name: String,
	pub group_id: String,
	pub share_url: Option<String>,
	pub created_at: i32,
	pub updated_at: i32,
	pub members : Option<Vec<User>>,
	pub messages: Option<MessagePreviewWrapper>,
}

#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct User {
	pub user_id: String,
	pub id: String,
	pub nickname: Option<String>,
	pub image_url: Option<String>,
	pub muted: bool,
}

#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct MessagePreviewWrapper {
	pub count: i32,
	pub last_message_id: String,
	pub preview: MessagePreview,
}

#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct MessagePreview {
	pub nickname: Option<String>,
	pub text: Option<String>,
	pub image_url: Option<String>,
	pub system: String,
}

#[derive(RustcDecodable, RustcEncodable, Debug)]
pub struct Message {
	pub id: String,
	pub name: String,
	pub text: Option<String>,
	pub group_id: String,
	pub user_id: String,
	pub favorited_by: Vec<String>,
	pub created_at: i32,
	pub system: bool,
}
