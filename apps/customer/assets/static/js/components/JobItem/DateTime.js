import styled from "styled-components";
import fonts from 'styles/fonts';
import colors from 'styles/colors';
export default styled.div`
  margin-top: 10px;
  margin-bottom: 10px;
  ${fonts('font-small')}
  color: ${colors.labelColor};
  text-align: right;
  padding-bottom: 15px;
`;
