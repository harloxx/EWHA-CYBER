import boto3
from botocore.exceptions import ClientError
import time
import logging

#s3 연동
s3=boto3.client('s3',region_name='ap-northeast-1',aws_access_key_id="ACCESS_KEY", aws_secret_access_key="ACCESS_KEY" )

#db 연동
dynamodb=boto3.resource('dynamodb',region_name='ap-northeast-1',aws_access_key_id="ACCESS_KEY", aws_secret_access_key="ACCESS_KEY")
table=dynamodb.Table('CC_2_1_1')

def upload_post(file_name, title, text, BUCKET, TABLE):
    s3.upload_file(file_name,BUCKET, file_name)
    img_url="https://cc21bucket.s3.ap-northeast-1.amazonaws.com/"+file_name
    item={'url':img_url,'title':title,'text':text,'date':time.strftime('%c', time.localtime(time.time()))}
    table.put_item(Item=item)

    

#모든 아이템 가져오기
def get_items(TABLE):
    dates = []
    titles = []
    urls = []
    texts = []
    response=table.scan()
    
    for i in range(response["Count"]):
        urls.append(response["Items"][i]['url'])
        dates.append(response["Items"][i]['date'])
        titles.append(response["Items"][i]['title'])
        texts.append(response["Items"][i]['text'])

    return dates, titles, urls, texts


def delete_post(key, BUCKET, TABLE):
    s3_file_url=table.get_item(Key={"date":key})['Item']['url']
    table.delete_item(
        Key={'date':key}
    )
    s3_file_key="uploads/"+s3_file_url.split('/uploads/')[1]
    s3.delete_object(Bucket=BUCKET, Key=s3_file_key)
    
    pass
