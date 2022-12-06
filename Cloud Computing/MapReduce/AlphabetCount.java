import java.io.IOException;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.TextInputFormat;
import org.apache.hadoop.mapred.TextOutputFormat;
public class AlphabetCount {
        public static void main(String[] args) throws IOException {
                // 1. configuration Mapper & Reducer of Hadoop
                JobConf conf = new JobConf();
                conf.setJobName("Alphabetcount");
                conf.setMapperClass(AlphabetCountMapper.class);
                conf.setReducerClass(AlphabetCountReducer.class);
                // 2. final output key type & value type
                conf.setOutputKeyClass(Text.class);
                conf.setOutputValueClass(IntWritable.class);

                // 3. in/output format
                conf.setInputFormat(TextInputFormat.class);
                conf.setOutputFormat(TextOutputFormat.class);
                // 4. set the path of file for read files
                // input path : args[0]
                // output path : args[1]
                FileInputFormat.setInputPaths(conf, new Path(args[0]));
                FileOutputFormat.setOutputPath(conf, new Path(args[1]));
                // 5. run job
                JobClient.runJob(conf);
                }
}
