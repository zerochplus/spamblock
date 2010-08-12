#============================================================================================================
#
#	拡張機能 - 出会いスパムキャンセラー！
#	0ch_spam_block.pl
#
#	by windyakin ◆windyaking
#
#	http://windyakin.net/
#
#	---------------------------------------------------------------------------
#
#	2010.06.17 start
#
#============================================================================================================
package ZPL_spamblock;

#------------------------------------------------------------------------------------------------------------
#
#	コンストラクタ
#	-------------------------------------------------------------------------------------
#	@param	なし
#	@return	オブジェクト
#
#------------------------------------------------------------------------------------------------------------
sub new
{
	my $this = shift;
	my $obj={};
	bless($obj,$this);
	return $obj;
}

#------------------------------------------------------------------------------------------------------------
#
#	拡張機能名称取得
#	-------------------------------------------------------------------------------------
#	@param	なし
#	@return	名称文字列
#
#------------------------------------------------------------------------------------------------------------
sub getName
{
	my	$this = shift;
	return '出会いスパムキャンセラー';
}

#------------------------------------------------------------------------------------------------------------
#
#	拡張機能説明取得
#	-------------------------------------------------------------------------------------
#	@param	なし
#	@return	説明文字列
#
#------------------------------------------------------------------------------------------------------------
sub getExplanation
{
	my	$this = shift;
	return 'URLを調べて解析します';
}

#------------------------------------------------------------------------------------------------------------
#
#	拡張機能タイプ取得
#	-------------------------------------------------------------------------------------
#	@param	なし
#	@return	拡張機能タイプ(スレ立て:1,レス:2,read:4,index:8)
#
#------------------------------------------------------------------------------------------------------------
sub getType
{
	my	$this = shift;
	return (1 | 2);
}

#------------------------------------------------------------------------------------------------------------
#
#	拡張機能実行インタフェイス
#	-------------------------------------------------------------------------------------
#	@param	$sys	MELKOR
#	@param	$form	SAMWISE
#	@return	正常終了の場合は0
#
#------------------------------------------------------------------------------------------------------------
sub execute
{
	my $this = shift;
	my ($sys, $form) = @_;
	
	# メッセージを取得
	my $mes = $form->Get('MESSAGE');
	
	if ( $mes =~ /h?ttp:\/\/([0-9a-zA-Z\.\-]+)(\/)?/ ) {
		
		# ホストを調査
		my $bin_addr = gethostbyname($1);
		my $result = sprintf("%vd", $bin_addr);
		
		# エラーを返すよ
		if ( $result eq "66.71.248.210" ) {
			&PrintBBSError ( $sys, $form, 600 )
		}
		
	}
	
	return 0;
}

#------------------------------------------------------------------------------------------------------------
#
#	なんちゃってbbs.cgiエラーページ表示
#	-------------------------------------------------------------------------------------
#	@param	$sys	MELKOR
#	@param	$form	SAMWISE
#	@param	$err	エラー番号
#	@return	なし
#	exit	エラー番号
#
#------------------------------------------------------------------------------------------------------------
sub PrintBBSError
{
	my ($sys,$form,$err) = @_;
	my $SYS;
	
	require('./module/radagast.pl');
	require('./module/isildur.pl');
	require('./module/thorin.pl');
	
	$SYS->{'SYS'}		= $sys;
	$SYS->{'FORM'}		= $form;
	$SYS->{'COOKIE'}	= new RADAGAST;
	$SYS->{'COOKIE'}->Init();
	$SYS->{'SET'}		= new ISILDUR;
	$SYS->{'SET'}->Load($sys);
	my $Page = new THORIN;
	
	require('./module/orald.pl');
	$ERROR = new ORALD;
	$ERROR->Load($sys);
	
	$ERROR->Print($SYS,$Page,$err,$sys->Get('AGENT'));
	
	$Page->Flush('',0,0);
	
	exit($err);
}

#============================================================================================================
#	Module END
#============================================================================================================
1;
__END__
