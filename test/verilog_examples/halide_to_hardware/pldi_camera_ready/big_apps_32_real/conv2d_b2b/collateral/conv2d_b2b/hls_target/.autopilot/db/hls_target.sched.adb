<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<!DOCTYPE boost_serialization>
<boost_serialization signature="serialization::archive" version="14">
<syndb class_id="0" tracking_level="0" version="0">
	<userIPLatency>-1</userIPLatency>
	<userIPName></userIPName>
	<cdfg class_id="1" tracking_level="1" version="0" object_id="_0">
		<name>hls_target</name>
		<ret_bitwidth>0</ret_bitwidth>
		<ports class_id="2" tracking_level="0" version="0">
			<count>4</count>
			<item_version>0</item_version>
			<item class_id="3" tracking_level="1" version="0" object_id="_1">
				<Value class_id="4" tracking_level="0" version="0">
					<Obj class_id="5" tracking_level="0" version="0">
						<type>1</type>
						<id>1</id>
						<name>hw_input_V_value_V</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo class_id="6" tracking_level="0" version="0">
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName>hw_input.V.value.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>32</bitwidth>
				</Value>
				<direction>0</direction>
				<if_type>0</if_type>
				<array_size>0</array_size>
				<bit_vecs class_id="7" tracking_level="0" version="0">
					<count>0</count>
					<item_version>0</item_version>
				</bit_vecs>
			</item>
			<item class_id_reference="3" object_id="_2">
				<Value>
					<Obj>
						<type>1</type>
						<id>2</id>
						<name>hw_input_V_last_V</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName>hw_input.V.last.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>1</bitwidth>
				</Value>
				<direction>0</direction>
				<if_type>0</if_type>
				<array_size>0</array_size>
				<bit_vecs>
					<count>0</count>
					<item_version>0</item_version>
				</bit_vecs>
			</item>
			<item class_id_reference="3" object_id="_3">
				<Value>
					<Obj>
						<type>1</type>
						<id>3</id>
						<name>hw_output_V_value_V</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName>hw_output.V.value.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>32</bitwidth>
				</Value>
				<direction>1</direction>
				<if_type>0</if_type>
				<array_size>0</array_size>
				<bit_vecs>
					<count>0</count>
					<item_version>0</item_version>
				</bit_vecs>
			</item>
			<item class_id_reference="3" object_id="_4">
				<Value>
					<Obj>
						<type>1</type>
						<id>4</id>
						<name>hw_output_V_last_V</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName>hw_output.V.last.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>1</bitwidth>
				</Value>
				<direction>1</direction>
				<if_type>0</if_type>
				<array_size>0</array_size>
				<bit_vecs>
					<count>0</count>
					<item_version>0</item_version>
				</bit_vecs>
			</item>
		</ports>
		<nodes class_id="8" tracking_level="0" version="0">
			<count>10</count>
			<item_version>0</item_version>
			<item class_id="9" tracking_level="1" version="0" object_id="_5">
				<Value>
					<Obj>
						<type>0</type>
						<id>11</id>
						<name>p_hw_input_stencil_st</name>
						<fileName>hls_target.cpp</fileName>
						<fileDirectory>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</fileDirectory>
						<lineNumber>50</lineNumber>
						<contextFuncName>hls_target</contextFuncName>
						<inlineStackInfo>
							<count>1</count>
							<item_version>0</item_version>
							<item class_id="10" tracking_level="0" version="0">
								<first>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</first>
								<second class_id="11" tracking_level="0" version="0">
									<count>1</count>
									<item_version>0</item_version>
									<item class_id="12" tracking_level="0" version="0">
										<first class_id="13" tracking_level="0" version="0">
											<first>hls_target.cpp</first>
											<second>hls_target</second>
										</first>
										<second>50</second>
									</item>
								</second>
							</item>
						</inlineStackInfo>
						<originalName>_hw_input_stencil_stream.V.value.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>288</bitwidth>
				</Value>
				<oprand_edges>
					<count>1</count>
					<item_version>0</item_version>
					<item>37</item>
				</oprand_edges>
				<opcode>alloca</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_6">
				<Value>
					<Obj>
						<type>0</type>
						<id>15</id>
						<name>p_mul_stencil_update_1</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>32</bitwidth>
				</Value>
				<oprand_edges>
					<count>1</count>
					<item_version>0</item_version>
					<item>38</item>
				</oprand_edges>
				<opcode>alloca</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_7">
				<Value>
					<Obj>
						<type>0</type>
						<id>19</id>
						<name>p_mul_stencil_stream_s</name>
						<fileName>hls_target.cpp</fileName>
						<fileDirectory>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</fileDirectory>
						<lineNumber>146</lineNumber>
						<contextFuncName>hls_target</contextFuncName>
						<inlineStackInfo>
							<count>1</count>
							<item_version>0</item_version>
							<item>
								<first>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</first>
								<second>
									<count>1</count>
									<item_version>0</item_version>
									<item>
										<first>
											<first>hls_target.cpp</first>
											<second>hls_target</second>
										</first>
										<second>146</second>
									</item>
								</second>
							</item>
						</inlineStackInfo>
						<originalName>_mul_stencil_stream.V.value.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>128</bitwidth>
				</Value>
				<oprand_edges>
					<count>1</count>
					<item_version>0</item_version>
					<item>39</item>
				</oprand_edges>
				<opcode>alloca</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_8">
				<Value>
					<Obj>
						<type>0</type>
						<id>23</id>
						<name>p_p2_mul1_stencil_str</name>
						<fileName>hls_target.cpp</fileName>
						<fileDirectory>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</fileDirectory>
						<lineNumber>155</lineNumber>
						<contextFuncName>hls_target</contextFuncName>
						<inlineStackInfo>
							<count>1</count>
							<item_version>0</item_version>
							<item>
								<first>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</first>
								<second>
									<count>1</count>
									<item_version>0</item_version>
									<item>
										<first>
											<first>hls_target.cpp</first>
											<second>hls_target</second>
										</first>
										<second>155</second>
									</item>
								</second>
							</item>
						</inlineStackInfo>
						<originalName>_p2_mul1_stencil_stream.V.value.V</originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>32</bitwidth>
				</Value>
				<oprand_edges>
					<count>1</count>
					<item_version>0</item_version>
					<item>40</item>
				</oprand_edges>
				<opcode>alloca</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_9">
				<Value>
					<Obj>
						<type>0</type>
						<id>29</id>
						<name></name>
						<fileName>hls_target.cpp</fileName>
						<fileDirectory>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</fileDirectory>
						<lineNumber>54</lineNumber>
						<contextFuncName>hls_target</contextFuncName>
						<inlineStackInfo>
							<count>1</count>
							<item_version>0</item_version>
							<item>
								<first>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</first>
								<second>
									<count>1</count>
									<item_version>0</item_version>
									<item>
										<first>
											<first>hls_target.cpp</first>
											<second>hls_target</second>
										</first>
										<second>54</second>
									</item>
								</second>
							</item>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<oprand_edges>
					<count>4</count>
					<item_version>0</item_version>
					<item>42</item>
					<item>43</item>
					<item>44</item>
					<item>45</item>
				</oprand_edges>
				<opcode>call</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_10">
				<Value>
					<Obj>
						<type>0</type>
						<id>30</id>
						<name></name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<oprand_edges>
					<count>5</count>
					<item_version>0</item_version>
					<item>47</item>
					<item>48</item>
					<item>49</item>
					<item>283</item>
					<item>284</item>
				</oprand_edges>
				<opcode>call</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_11">
				<Value>
					<Obj>
						<type>0</type>
						<id>31</id>
						<name></name>
						<fileName>hls_target.cpp</fileName>
						<fileDirectory>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</fileDirectory>
						<lineNumber>150</lineNumber>
						<contextFuncName>hls_target</contextFuncName>
						<inlineStackInfo>
							<count>1</count>
							<item_version>0</item_version>
							<item>
								<first>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</first>
								<second>
									<count>1</count>
									<item_version>0</item_version>
									<item>
										<first>
											<first>hls_target.cpp</first>
											<second>hls_target</second>
										</first>
										<second>150</second>
									</item>
								</second>
							</item>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<oprand_edges>
					<count>5</count>
					<item_version>0</item_version>
					<item>51</item>
					<item>52</item>
					<item>53</item>
					<item>282</item>
					<item>285</item>
				</oprand_edges>
				<opcode>call</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_12">
				<Value>
					<Obj>
						<type>0</type>
						<id>32</id>
						<name></name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<oprand_edges>
					<count>5</count>
					<item_version>0</item_version>
					<item>55</item>
					<item>56</item>
					<item>57</item>
					<item>281</item>
					<item>286</item>
				</oprand_edges>
				<opcode>call</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_13">
				<Value>
					<Obj>
						<type>0</type>
						<id>33</id>
						<name></name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<oprand_edges>
					<count>6</count>
					<item_version>0</item_version>
					<item>59</item>
					<item>60</item>
					<item>61</item>
					<item>62</item>
					<item>280</item>
					<item>287</item>
				</oprand_edges>
				<opcode>call</opcode>
				<m_Display>0</m_Display>
			</item>
			<item class_id_reference="9" object_id="_14">
				<Value>
					<Obj>
						<type>0</type>
						<id>34</id>
						<name></name>
						<fileName>hls_target.cpp</fileName>
						<fileDirectory>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</fileDirectory>
						<lineNumber>252</lineNumber>
						<contextFuncName>hls_target</contextFuncName>
						<inlineStackInfo>
							<count>1</count>
							<item_version>0</item_version>
							<item>
								<first>/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b</first>
								<second>
									<count>1</count>
									<item_version>0</item_version>
									<item>
										<first>
											<first>hls_target.cpp</first>
											<second>hls_target</second>
										</first>
										<second>252</second>
									</item>
								</second>
							</item>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<oprand_edges>
					<count>0</count>
					<item_version>0</item_version>
				</oprand_edges>
				<opcode>ret</opcode>
				<m_Display>0</m_Display>
			</item>
		</nodes>
		<consts class_id="15" tracking_level="0" version="0">
			<count>6</count>
			<item_version>0</item_version>
			<item class_id="16" tracking_level="1" version="0" object_id="_15">
				<Value>
					<Obj>
						<type>2</type>
						<id>36</id>
						<name>empty</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>64</bitwidth>
				</Value>
				<const_type>0</const_type>
				<content>1</content>
			</item>
			<item class_id_reference="16" object_id="_16">
				<Value>
					<Obj>
						<type>2</type>
						<id>41</id>
						<name>linebuffer_1</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<const_type>6</const_type>
				<content>&lt;constant:linebuffer.1&gt;</content>
			</item>
			<item class_id_reference="16" object_id="_17">
				<Value>
					<Obj>
						<type>2</type>
						<id>46</id>
						<name>Loop_1_proc</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<const_type>6</const_type>
				<content>&lt;constant:Loop_1_proc&gt;</content>
			</item>
			<item class_id_reference="16" object_id="_18">
				<Value>
					<Obj>
						<type>2</type>
						<id>50</id>
						<name>linebuffer_2</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<const_type>6</const_type>
				<content>&lt;constant:linebuffer.2&gt;</content>
			</item>
			<item class_id_reference="16" object_id="_19">
				<Value>
					<Obj>
						<type>2</type>
						<id>54</id>
						<name>Loop_2_proc</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<const_type>6</const_type>
				<content>&lt;constant:Loop_2_proc&gt;</content>
			</item>
			<item class_id_reference="16" object_id="_20">
				<Value>
					<Obj>
						<type>2</type>
						<id>58</id>
						<name>Loop_3_proc</name>
						<fileName></fileName>
						<fileDirectory></fileDirectory>
						<lineNumber>0</lineNumber>
						<contextFuncName></contextFuncName>
						<inlineStackInfo>
							<count>0</count>
							<item_version>0</item_version>
						</inlineStackInfo>
						<originalName></originalName>
						<rtlName></rtlName>
						<coreName></coreName>
					</Obj>
					<bitwidth>0</bitwidth>
				</Value>
				<const_type>6</const_type>
				<content>&lt;constant:Loop_3_proc&gt;</content>
			</item>
		</consts>
		<blocks class_id="17" tracking_level="0" version="0">
			<count>1</count>
			<item_version>0</item_version>
			<item class_id="18" tracking_level="1" version="0" object_id="_21">
				<Obj>
					<type>3</type>
					<id>35</id>
					<name>hls_target</name>
					<fileName></fileName>
					<fileDirectory></fileDirectory>
					<lineNumber>0</lineNumber>
					<contextFuncName></contextFuncName>
					<inlineStackInfo>
						<count>0</count>
						<item_version>0</item_version>
					</inlineStackInfo>
					<originalName></originalName>
					<rtlName></rtlName>
					<coreName></coreName>
				</Obj>
				<node_objs>
					<count>10</count>
					<item_version>0</item_version>
					<item>11</item>
					<item>15</item>
					<item>19</item>
					<item>23</item>
					<item>29</item>
					<item>30</item>
					<item>31</item>
					<item>32</item>
					<item>33</item>
					<item>34</item>
				</node_objs>
			</item>
		</blocks>
		<edges class_id="19" tracking_level="0" version="0">
			<count>29</count>
			<item_version>0</item_version>
			<item class_id="20" tracking_level="1" version="0" object_id="_22">
				<id>37</id>
				<edge_type>1</edge_type>
				<source_obj>36</source_obj>
				<sink_obj>11</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_23">
				<id>38</id>
				<edge_type>1</edge_type>
				<source_obj>36</source_obj>
				<sink_obj>15</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_24">
				<id>39</id>
				<edge_type>1</edge_type>
				<source_obj>36</source_obj>
				<sink_obj>19</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_25">
				<id>40</id>
				<edge_type>1</edge_type>
				<source_obj>36</source_obj>
				<sink_obj>23</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_26">
				<id>42</id>
				<edge_type>1</edge_type>
				<source_obj>41</source_obj>
				<sink_obj>29</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_27">
				<id>43</id>
				<edge_type>1</edge_type>
				<source_obj>1</source_obj>
				<sink_obj>29</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_28">
				<id>44</id>
				<edge_type>1</edge_type>
				<source_obj>2</source_obj>
				<sink_obj>29</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_29">
				<id>45</id>
				<edge_type>1</edge_type>
				<source_obj>11</source_obj>
				<sink_obj>29</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_30">
				<id>47</id>
				<edge_type>1</edge_type>
				<source_obj>46</source_obj>
				<sink_obj>30</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_31">
				<id>48</id>
				<edge_type>1</edge_type>
				<source_obj>11</source_obj>
				<sink_obj>30</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_32">
				<id>49</id>
				<edge_type>1</edge_type>
				<source_obj>15</source_obj>
				<sink_obj>30</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_33">
				<id>51</id>
				<edge_type>1</edge_type>
				<source_obj>50</source_obj>
				<sink_obj>31</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_34">
				<id>52</id>
				<edge_type>1</edge_type>
				<source_obj>15</source_obj>
				<sink_obj>31</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_35">
				<id>53</id>
				<edge_type>1</edge_type>
				<source_obj>19</source_obj>
				<sink_obj>31</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_36">
				<id>55</id>
				<edge_type>1</edge_type>
				<source_obj>54</source_obj>
				<sink_obj>32</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_37">
				<id>56</id>
				<edge_type>1</edge_type>
				<source_obj>19</source_obj>
				<sink_obj>32</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_38">
				<id>57</id>
				<edge_type>1</edge_type>
				<source_obj>23</source_obj>
				<sink_obj>32</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_39">
				<id>59</id>
				<edge_type>1</edge_type>
				<source_obj>58</source_obj>
				<sink_obj>33</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_40">
				<id>60</id>
				<edge_type>1</edge_type>
				<source_obj>23</source_obj>
				<sink_obj>33</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_41">
				<id>61</id>
				<edge_type>1</edge_type>
				<source_obj>3</source_obj>
				<sink_obj>33</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_42">
				<id>62</id>
				<edge_type>1</edge_type>
				<source_obj>4</source_obj>
				<sink_obj>33</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_43">
				<id>280</id>
				<edge_type>4</edge_type>
				<source_obj>32</source_obj>
				<sink_obj>33</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_44">
				<id>281</id>
				<edge_type>4</edge_type>
				<source_obj>31</source_obj>
				<sink_obj>32</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_45">
				<id>282</id>
				<edge_type>4</edge_type>
				<source_obj>30</source_obj>
				<sink_obj>31</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_46">
				<id>283</id>
				<edge_type>4</edge_type>
				<source_obj>29</source_obj>
				<sink_obj>30</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_47">
				<id>284</id>
				<edge_type>4</edge_type>
				<source_obj>29</source_obj>
				<sink_obj>30</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_48">
				<id>285</id>
				<edge_type>4</edge_type>
				<source_obj>30</source_obj>
				<sink_obj>31</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_49">
				<id>286</id>
				<edge_type>4</edge_type>
				<source_obj>31</source_obj>
				<sink_obj>32</sink_obj>
			</item>
			<item class_id_reference="20" object_id="_50">
				<id>287</id>
				<edge_type>4</edge_type>
				<source_obj>32</source_obj>
				<sink_obj>33</sink_obj>
			</item>
		</edges>
	</cdfg>
	<cdfg_regions class_id="21" tracking_level="0" version="0">
		<count>1</count>
		<item_version>0</item_version>
		<item class_id="22" tracking_level="1" version="0" object_id="_51">
			<mId>1</mId>
			<mTag>hls_target</mTag>
			<mType>0</mType>
			<sub_regions>
				<count>0</count>
				<item_version>0</item_version>
			</sub_regions>
			<basic_blocks>
				<count>1</count>
				<item_version>0</item_version>
				<item>35</item>
			</basic_blocks>
			<mII>-1</mII>
			<mDepth>-1</mDepth>
			<mMinTripCount>-1</mMinTripCount>
			<mMaxTripCount>-1</mMaxTripCount>
			<mMinLatency>2077921</mMinLatency>
			<mMaxLatency>-1</mMaxLatency>
			<mIsDfPipe>1</mIsDfPipe>
			<mDfPipe class_id="23" tracking_level="1" version="0" object_id="_52">
				<port_list class_id="24" tracking_level="0" version="0">
					<count>0</count>
					<item_version>0</item_version>
				</port_list>
				<process_list class_id="25" tracking_level="0" version="0">
					<count>5</count>
					<item_version>0</item_version>
					<item class_id="26" tracking_level="1" version="0" object_id="_53">
						<type>0</type>
						<name>linebuffer_1_U0</name>
						<ssdmobj_id>29</ssdmobj_id>
						<pins class_id="27" tracking_level="0" version="0">
							<count>3</count>
							<item_version>0</item_version>
							<item class_id="28" tracking_level="1" version="0" object_id="_54">
								<port class_id="29" tracking_level="1" version="0" object_id="_55">
									<name>in_axi_stream_V_value_V</name>
									<dir>3</dir>
									<type>0</type>
								</port>
								<inst class_id="30" tracking_level="1" version="0" object_id="_56">
									<type>0</type>
									<name>linebuffer_1_U0</name>
									<ssdmobj_id>29</ssdmobj_id>
								</inst>
							</item>
							<item class_id_reference="28" object_id="_57">
								<port class_id_reference="29" object_id="_58">
									<name>in_axi_stream_V_last_V</name>
									<dir>3</dir>
									<type>0</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_56"></inst>
							</item>
							<item class_id_reference="28" object_id="_59">
								<port class_id_reference="29" object_id="_60">
									<name>out_stream_V_value_V</name>
									<dir>0</dir>
									<type>1</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_56"></inst>
							</item>
						</pins>
					</item>
					<item class_id_reference="26" object_id="_61">
						<type>0</type>
						<name>Loop_1_proc_U0</name>
						<ssdmobj_id>30</ssdmobj_id>
						<pins>
							<count>2</count>
							<item_version>0</item_version>
							<item class_id_reference="28" object_id="_62">
								<port class_id_reference="29" object_id="_63">
									<name>p_hw_input_stencil_stream_V_value_V</name>
									<dir>0</dir>
									<type>0</type>
								</port>
								<inst class_id_reference="30" object_id="_64">
									<type>0</type>
									<name>Loop_1_proc_U0</name>
									<ssdmobj_id>30</ssdmobj_id>
								</inst>
							</item>
							<item class_id_reference="28" object_id="_65">
								<port class_id_reference="29" object_id="_66">
									<name>p_mul_stencil_update_stream_V_value_V</name>
									<dir>0</dir>
									<type>1</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_64"></inst>
							</item>
						</pins>
					</item>
					<item class_id_reference="26" object_id="_67">
						<type>0</type>
						<name>linebuffer_2_U0</name>
						<ssdmobj_id>31</ssdmobj_id>
						<pins>
							<count>2</count>
							<item_version>0</item_version>
							<item class_id_reference="28" object_id="_68">
								<port class_id_reference="29" object_id="_69">
									<name>in_stream_V_value_V</name>
									<dir>0</dir>
									<type>0</type>
								</port>
								<inst class_id_reference="30" object_id="_70">
									<type>0</type>
									<name>linebuffer_2_U0</name>
									<ssdmobj_id>31</ssdmobj_id>
								</inst>
							</item>
							<item class_id_reference="28" object_id="_71">
								<port class_id_reference="29" object_id="_72">
									<name>out_stream_V_value_V</name>
									<dir>0</dir>
									<type>1</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_70"></inst>
							</item>
						</pins>
					</item>
					<item class_id_reference="26" object_id="_73">
						<type>0</type>
						<name>Loop_2_proc_U0</name>
						<ssdmobj_id>32</ssdmobj_id>
						<pins>
							<count>2</count>
							<item_version>0</item_version>
							<item class_id_reference="28" object_id="_74">
								<port class_id_reference="29" object_id="_75">
									<name>p_mul_stencil_stream_V_value_V</name>
									<dir>0</dir>
									<type>0</type>
								</port>
								<inst class_id_reference="30" object_id="_76">
									<type>0</type>
									<name>Loop_2_proc_U0</name>
									<ssdmobj_id>32</ssdmobj_id>
								</inst>
							</item>
							<item class_id_reference="28" object_id="_77">
								<port class_id_reference="29" object_id="_78">
									<name>p_p2_mul1_stencil_stream_V_value_V</name>
									<dir>0</dir>
									<type>1</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_76"></inst>
							</item>
						</pins>
					</item>
					<item class_id_reference="26" object_id="_79">
						<type>0</type>
						<name>Loop_3_proc_U0</name>
						<ssdmobj_id>33</ssdmobj_id>
						<pins>
							<count>3</count>
							<item_version>0</item_version>
							<item class_id_reference="28" object_id="_80">
								<port class_id_reference="29" object_id="_81">
									<name>p_p2_mul1_stencil_stream_V_value_V</name>
									<dir>0</dir>
									<type>0</type>
								</port>
								<inst class_id_reference="30" object_id="_82">
									<type>0</type>
									<name>Loop_3_proc_U0</name>
									<ssdmobj_id>33</ssdmobj_id>
								</inst>
							</item>
							<item class_id_reference="28" object_id="_83">
								<port class_id_reference="29" object_id="_84">
									<name>hw_output_V_value_V</name>
									<dir>3</dir>
									<type>1</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_82"></inst>
							</item>
							<item class_id_reference="28" object_id="_85">
								<port class_id_reference="29" object_id="_86">
									<name>hw_output_V_last_V</name>
									<dir>3</dir>
									<type>1</type>
								</port>
								<inst class_id_reference="30" object_id_reference="_82"></inst>
							</item>
						</pins>
					</item>
				</process_list>
				<channel_list class_id="31" tracking_level="0" version="0">
					<count>4</count>
					<item_version>0</item_version>
					<item class_id="32" tracking_level="1" version="0" object_id="_87">
						<type>1</type>
						<name>p_hw_input_stencil_st</name>
						<ssdmobj_id>11</ssdmobj_id>
						<ctype>0</ctype>
						<depth>1</depth>
						<bitwidth>288</bitwidth>
						<source class_id_reference="28" object_id="_88">
							<port class_id_reference="29" object_id="_89">
								<name>in</name>
								<dir>3</dir>
								<type>0</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_56"></inst>
						</source>
						<sink class_id_reference="28" object_id="_90">
							<port class_id_reference="29" object_id="_91">
								<name>out</name>
								<dir>3</dir>
								<type>1</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_64"></inst>
						</sink>
					</item>
					<item class_id_reference="32" object_id="_92">
						<type>1</type>
						<name>p_mul_stencil_update_1</name>
						<ssdmobj_id>15</ssdmobj_id>
						<ctype>0</ctype>
						<depth>1</depth>
						<bitwidth>32</bitwidth>
						<source class_id_reference="28" object_id="_93">
							<port class_id_reference="29" object_id="_94">
								<name>in</name>
								<dir>3</dir>
								<type>0</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_64"></inst>
						</source>
						<sink class_id_reference="28" object_id="_95">
							<port class_id_reference="29" object_id="_96">
								<name>out</name>
								<dir>3</dir>
								<type>1</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_70"></inst>
						</sink>
					</item>
					<item class_id_reference="32" object_id="_97">
						<type>1</type>
						<name>p_mul_stencil_stream_s</name>
						<ssdmobj_id>19</ssdmobj_id>
						<ctype>0</ctype>
						<depth>1</depth>
						<bitwidth>128</bitwidth>
						<source class_id_reference="28" object_id="_98">
							<port class_id_reference="29" object_id="_99">
								<name>in</name>
								<dir>3</dir>
								<type>0</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_70"></inst>
						</source>
						<sink class_id_reference="28" object_id="_100">
							<port class_id_reference="29" object_id="_101">
								<name>out</name>
								<dir>3</dir>
								<type>1</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_76"></inst>
						</sink>
					</item>
					<item class_id_reference="32" object_id="_102">
						<type>1</type>
						<name>p_p2_mul1_stencil_str</name>
						<ssdmobj_id>23</ssdmobj_id>
						<ctype>0</ctype>
						<depth>1</depth>
						<bitwidth>32</bitwidth>
						<source class_id_reference="28" object_id="_103">
							<port class_id_reference="29" object_id="_104">
								<name>in</name>
								<dir>3</dir>
								<type>0</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_76"></inst>
						</source>
						<sink class_id_reference="28" object_id="_105">
							<port class_id_reference="29" object_id="_106">
								<name>out</name>
								<dir>3</dir>
								<type>1</type>
							</port>
							<inst class_id_reference="30" object_id_reference="_82"></inst>
						</sink>
					</item>
				</channel_list>
				<net_list class_id="33" tracking_level="0" version="0">
					<count>0</count>
					<item_version>0</item_version>
				</net_list>
			</mDfPipe>
		</item>
	</cdfg_regions>
	<fsm class_id="-1"></fsm>
	<res class_id="-1"></res>
	<node_label_latency class_id="36" tracking_level="0" version="0">
		<count>10</count>
		<item_version>0</item_version>
		<item class_id="37" tracking_level="0" version="0">
			<first>11</first>
			<second class_id="38" tracking_level="0" version="0">
				<first>0</first>
				<second>0</second>
			</second>
		</item>
		<item>
			<first>15</first>
			<second>
				<first>0</first>
				<second>0</second>
			</second>
		</item>
		<item>
			<first>19</first>
			<second>
				<first>0</first>
				<second>0</second>
			</second>
		</item>
		<item>
			<first>23</first>
			<second>
				<first>0</first>
				<second>0</second>
			</second>
		</item>
		<item>
			<first>29</first>
			<second>
				<first>0</first>
				<second>1</second>
			</second>
		</item>
		<item>
			<first>30</first>
			<second>
				<first>2</first>
				<second>1</second>
			</second>
		</item>
		<item>
			<first>31</first>
			<second>
				<first>4</first>
				<second>1</second>
			</second>
		</item>
		<item>
			<first>32</first>
			<second>
				<first>6</first>
				<second>1</second>
			</second>
		</item>
		<item>
			<first>33</first>
			<second>
				<first>8</first>
				<second>1</second>
			</second>
		</item>
		<item>
			<first>34</first>
			<second>
				<first>9</first>
				<second>0</second>
			</second>
		</item>
	</node_label_latency>
	<bblk_ent_exit class_id="39" tracking_level="0" version="0">
		<count>1</count>
		<item_version>0</item_version>
		<item class_id="40" tracking_level="0" version="0">
			<first>35</first>
			<second class_id="41" tracking_level="0" version="0">
				<first>0</first>
				<second>9</second>
			</second>
		</item>
	</bblk_ent_exit>
	<regions class_id="42" tracking_level="0" version="0">
		<count>1</count>
		<item_version>0</item_version>
		<item class_id="43" tracking_level="1" version="0" object_id="_107">
			<region_name>hls_target</region_name>
			<basic_blocks>
				<count>1</count>
				<item_version>0</item_version>
				<item>35</item>
			</basic_blocks>
			<nodes>
				<count>30</count>
				<item_version>0</item_version>
				<item>5</item>
				<item>6</item>
				<item>7</item>
				<item>8</item>
				<item>9</item>
				<item>10</item>
				<item>11</item>
				<item>12</item>
				<item>13</item>
				<item>14</item>
				<item>15</item>
				<item>16</item>
				<item>17</item>
				<item>18</item>
				<item>19</item>
				<item>20</item>
				<item>21</item>
				<item>22</item>
				<item>23</item>
				<item>24</item>
				<item>25</item>
				<item>26</item>
				<item>27</item>
				<item>28</item>
				<item>29</item>
				<item>30</item>
				<item>31</item>
				<item>32</item>
				<item>33</item>
				<item>34</item>
			</nodes>
			<anchor_node>-1</anchor_node>
			<region_type>16</region_type>
			<interval>0</interval>
			<pipe_depth>0</pipe_depth>
		</item>
	</regions>
	<dp_fu_nodes class_id="44" tracking_level="0" version="0">
		<count>0</count>
		<item_version>0</item_version>
	</dp_fu_nodes>
	<dp_fu_nodes_expression class_id="45" tracking_level="0" version="0">
		<count>0</count>
		<item_version>0</item_version>
	</dp_fu_nodes_expression>
	<dp_fu_nodes_module>
		<count>0</count>
		<item_version>0</item_version>
	</dp_fu_nodes_module>
	<dp_fu_nodes_io>
		<count>0</count>
		<item_version>0</item_version>
	</dp_fu_nodes_io>
	<return_ports>
		<count>0</count>
		<item_version>0</item_version>
	</return_ports>
	<dp_mem_port_nodes class_id="46" tracking_level="0" version="0">
		<count>0</count>
		<item_version>0</item_version>
	</dp_mem_port_nodes>
	<dp_reg_nodes>
		<count>0</count>
		<item_version>0</item_version>
	</dp_reg_nodes>
	<dp_regname_nodes>
		<count>0</count>
		<item_version>0</item_version>
	</dp_regname_nodes>
	<dp_reg_phi>
		<count>0</count>
		<item_version>0</item_version>
	</dp_reg_phi>
	<dp_regname_phi>
		<count>0</count>
		<item_version>0</item_version>
	</dp_regname_phi>
	<dp_port_io_nodes class_id="47" tracking_level="0" version="0">
		<count>0</count>
		<item_version>0</item_version>
	</dp_port_io_nodes>
	<port2core class_id="48" tracking_level="0" version="0">
		<count>0</count>
		<item_version>0</item_version>
	</port2core>
	<node2core>
		<count>0</count>
		<item_version>0</item_version>
	</node2core>
</syndb>
</boost_serialization>

