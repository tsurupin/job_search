import styled from 'styled-components';
import colors from 'styles/colors';
import { Link } from 'react-router';

export const Wrapper = styled.li`
  margin-top: 20px;
  padding-bottom: 20px;
  list-style: none;
  border-bottom: 1px solid ${colors.listBorderColor};
`;

export const Form = styled.form`
  width: 100%;
  display: flex;
  justify-content: center;
`;

export const Row = styled.div`
  width: ${props => props.size}0%;
`;


export const UpdateButton = styled.button`
  color: ${props => props.disabled ? colors.leadSentenceColor : colors.primaryColor};
  cursor: ${props => props.disabled ? 'default' : 'pointer'};
  width: 56px;
  padding: 10px;
  &:hover {
    color: ${props => props.disabled ? colors.leadSentenceColor : colors.hoverPrimaryColor};;
  }
`;

export const CompanyWrapper = styled.div`
  display: flex;
  width: 100%;
 `;
export const CompanyInfo = styled.div`
  width: 78%;
`;

export const TitleLink = styled(Link)`
  font-size: 16px;
`;

export const Info = styled.p`
  font-size: 12px;
  margin-top: 5px;
  color: ${colors.leadSentenceColor};
`;

export const Icon = styled.span`
  width: 15%;
  margin-right: 7%;
  color: #009E5D;
  cursor: pointer;
`;
